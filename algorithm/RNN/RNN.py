# coding=utf-8
# 导入所需库，初始化随机生成器。Numpy是做代数的强大库
import copy, numpy as np
np.random.seed(1)

# compute sigmoid nonlinearity      # 激活函数 矩阵操作
def sigmoid(x):
    output = 1/(1+np.exp(-x))
    return output

# convert output of sigmoid function to its derivative # 求导函数
def sigmoid_output_to_derivative(output):
    return output*(1-output)        # sigmoid 求导


# training dataset generation
int2binary = {}                     # 我们做个映射，把一个整数映射到一串比特串。比特串的每一位作为RNN的输入
binary_dim = 8                      # 比特串的最大长度

largest_number = pow(2,binary_dim)  # 计算8位比特串最大可能表示的整数

# int2binary和binary都是一个从整数到比特串的表示查找表。这样比较清晰
# binary = {00000000, 00000001, 00000010, ... , 11111111}
binary = np.unpackbits(
    np.array([range(largest_number)],dtype=np.uint8).T,axis=1)

# type(binary)     = ndarray
# type(int2binary) = dict
for i in range(largest_number):
    int2binary[i] = binary[i]


# input variables
alpha = 0.1                         # 学习步长设置为0.1
input_dim = 2                       # 每次我们喂给RNN的输入数据是两个比特
hidden_dim = 16                     # 这是隐层的比特数。也可以说是隐层神经元个数。隐层神经元个数如何影响收敛速度？  读者可以自行研究
output_dim = 1                      # 输出层我们仅仅预测一位求和值


# initialize neural network weights
# 这是输入层和隐层间的权重矩阵。所以就是输入层单元*隐层单元的矩阵（2 x 16 ）
synapse_0 = 2*np.random.random((input_dim,hidden_dim)) - 1
# 这是隐层和输出层间的权重矩阵。所以就是隐层单元*输出层单元的矩阵（16*1 ）
synapse_1 = 2*np.random.random((hidden_dim,output_dim)) - 1
# 这是连接上一个时间戳隐层和当前时间戳隐层的矩阵，同时也是连接当前时间戳隐层和下一个时间戳隐层的矩阵。所以矩阵是隐层单元*隐层单元（16 x 16）
synapse_h = 2*np.random.random((hidden_dim,hidden_dim)) - 1

# 这些变量保存对于权重矩阵的更新值，我们的目的不就是训练好的权重矩阵吗？
# 我们在每次迭代积累权重更新值，然后一起更新
synapse_0_update = np.zeros_like(synapse_0)
synapse_1_update = np.zeros_like(synapse_1)
synapse_h_update = np.zeros_like(synapse_h)

# training logic
# 我们要迭代训练10,000个训练样本
for j in range(10000):
    
    # generate a simple addition problem (a + b = c)
    # int version 我们将要生成一个随机加和问题。
    # 我随机生成的整数不会超过我们所能表达的整数的一半
    # 否则两个整数相加就有可能超过我们可以用比特串表达的整数
    a_int = np.random.randint(largest_number/2)
    a = int2binary[a_int] # binary encoding     # 查找整数a对应的比特串

    b_int = np.random.randint(largest_number/2) # int version 找整数b对应的比特串
    b = int2binary[b_int]                       # binary encoding 找整数b对应的比特串

    # true answer
    c_int = a_int + b_int                       # 计算应该得出结果
    c = int2binary[c_int]                       # 查找计算结果对应的比特串
    
    # where we'll store our best guess (binary encoded)
    d = np.zeros_like(c)                        # 得到一个空的比特串来存储我们RNN神经网络的预测值

    overallError = 0                            # 初始化错误估计，作为收敛的依据
    
    layer_2_deltas = list()                     # 这两个列表是在每个时间戳跟踪输出层求导和隐层值的列表
    layer_1_values = list()
    layer_1_values.append(np.zeros(hidden_dim)) # 开始时没有上一个时间戳隐层，所有我们置为0
    
    # moving along the positions in the binary encoding
    for position in range(binary_dim):          # 这个迭代可能的比特串表达（8位比特串）
        
        # generate input and output
        X = np.array([[a[binary_dim - position - 1],b[binary_dim - position - 1]]]) # X就像是文章开头图片中的”layer_0″. X 是一个2个元素的列表，第一个元素是比特串a中的，第二个元素是比特串b中的。我们用position定位比特位，是自右向左的
        y = np.array([c[binary_dim - position - 1]]).T # 转置矩阵 我们的正确结果 (1或0)

        # hidden layer (input ~+ prev_hidden)
        # 这行是代码申神奇之处!!! 请看懂这一行!!!
        # 为了构造隐层，我们做两件事，第一步是从输入层传播到隐层(np.dot(X,synapse_0)) 输入X点乘权重
        # 第二步，我们把上一个时间戳的隐层值传播到当前隐层 (np.dot(prev_layer_1, synapse_h)
        # 最后我们把两个向量值相加! 最后交给sigmoid函数.
        # -1 表示最后的元素
        layer_1 = sigmoid(np.dot(X,synapse_0) + np.dot(layer_1_values[-1],synapse_h))

        # output layer (new binary representation)
        layer_2 = sigmoid(np.dot(layer_1,synapse_1)) # 这行很简单，把隐层传播到输出层，做预测

        # did we miss?... if so, by how much?
        layer_2_error = y - layer_2                  # 计算预测的错误偏差
        layer_2_deltas.append((layer_2_error)*sigmoid_output_to_derivative(layer_2))    # 计算并存储错误导数，在每个时间戳进行
        overallError += np.abs(layer_2_error[0])     # 计算错误的绝对值的和，积累起来
    
        # decode estimate so we can print it out
        d[binary_dim - position - 1] = np.round(layer_2[0][0]) # 估计输出值。并且保存在d中
        
        # store hidden layer so we can use it in the next timestep
        layer_1_values.append(copy.deepcopy(layer_1)) # 保存当前隐层值，作为下个时间戳的上个隐层值
    
    future_layer_1_delta = np.zeros(hidden_dim)
    
    for position in range(binary_dim):  # 所以，我们对于所有的时间戳做了前向传播，我们计算了输出层的求导并且把它们存在列表中。现在我们需要反向传播，从最后一个时间戳开始反向传播到第一个时间戳
        
        X = np.array([[a[position],b[position]]])   # 像我们之前一样获得输入数据
        layer_1 = layer_1_values[-position-1]       # 选择当前隐层
        prev_layer_1 = layer_1_values[-position-2]  # 选择上个时间戳隐层
        
        # error at output layer
        layer_2_delta = layer_2_deltas[-position-1] # 选择当前输出错误
        # error at hidden layer
        layer_1_delta = (future_layer_1_delta.dot(synapse_h.T) + layer_2_delta.dot(synapse_1.T)) * sigmoid_output_to_derivative(layer_1) # 这行在给定下一个时间戳隐层错误和当前输出错误的情况下，计算当前隐层错误

        # let's update all our weights so we can try again
        synapse_1_update += np.atleast_2d(layer_1).T.dot(layer_2_delta) # 现在我们在当前时间戳通过反向传播得到了求导，我们可以构造权重更新了（但暂时不更新权重）。我们等到完全反向传播后，才真正去更新权重。为什么？因为反向传播也是需要权重的。乱改权重是不合理的
        synapse_h_update += np.atleast_2d(prev_layer_1).T.dot(layer_1_delta)
        synapse_0_update += X.T.dot(layer_1_delta)
        
        future_layer_1_delta = layer_1_delta
    

    synapse_0 += synapse_0_update * alpha           # 现在我们反向传播完毕，可以真的更新所有权重了
    synapse_1 += synapse_1_update * alpha
    synapse_h += synapse_h_update * alpha    

    synapse_0_update *= 0
    synapse_1_update *= 0
    synapse_h_update *= 0
    
    # print out progress
    if(j % 1000 == 0):                              # 最后 一些log和输出看结果
        print "Error:" + str(overallError)
        print "Pred:" + str(d)
        print "True:" + str(c)
        out = 0
        for index,x in enumerate(reversed(d)):
            out += x*pow(2,index)
        print str(a_int) + " + " + str(b_int) + " = " + str(out)
        print "------------"