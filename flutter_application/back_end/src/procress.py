


from cmath import sqrt,pi,exp
import pandas as pd
import numpy as np
import scipy.stats as st


# gaussian function
def gaussian(mu, sigma2, x):
    ''' f takes in a mean and squared variance, and an input x
       and returns the gaussian value.'''
    coefficient = 1.0 / sqrt(2.0 * pi *sigma2)
    exponential = exp(-0.5 * (x-mu) ** 2 / sigma2)
    a = coefficient * exponential
    return 1-(1-st.norm.cdf(np.round(a.real*10.0,2)))*2


def convert_rssi(r1,r2,r3,r4):

    d_est1 = 1.0*(10**(-(r1 - -59)/(10*2)))
    d_est2 = 1.0*(10**(-(r2 - -59)/(10*2)))
    d_est3 = 1.0*(10**(-(r3 - -59)/(10*2)))
    d_est4 = 1.0*(10**(-(r4 - -59)/(10*2)))
    return [np.round(d_est1,3),np.round(d_est2,3),np.round(d_est3,3),np.round(d_est4,3),0.0]

def trilateration(rssi):
    

    a = np.array([[5,5],[0,0],[0,5],[5,0]])
    dist = rssi
    A  = []
    B = []
    # node_matrix = np.array(np.mat('0 0; 10 0; 0 10;10 10'), subok=True)
   
    dist = np.array(dist)

    x = a[:,0]
    y = a[:,1]
    k = x**2 + y **2

    for i  in range(1,len(dist)):
        A.append(np.array([x[i],y[i]]) - np.array([x[0],y[0]]))
        B.append(dist[0]**2 -dist[i]**2+k[i]-k[0])
    A = np.array(A)
    B = np.array(B)

    pos = (np.linalg.pinv(A)@B)/2
    print(pos)
    return np.round(pos,2)

def random_sampling(df, n):
    random_sample = np.random.choice(df,replace = False, size = n)
    return(random_sample)

class Kalmanfilter_dist():
    def __init__(self, dt, rssi1_std_meas, rssi2_std_meas, rssi3_std_meas, rssi4_std_meas):
        self.dt = dt
        self.u = 0

        self.x = np.matrix([[0], [0], [0], [0],[0], [0], [0], [0]])
        self.A = np.matrix([[1, 0, 0, 0, self.dt, 0, 0, 0],
                            [0, 1, 0, 0, 0, self.dt, 0, 0],
                            [0, 0, 1, 0, 0, 0, self.dt, 0],
                            [0, 0, 0, 1, 0, 0, 0, self.dt],
                            [0, 0, 0, 0, 1, 0, 0, 0],
                            [0, 0, 0, 0, 0, 1, 0, 0],
                            [0, 0, 0, 0, 0, 0, 1, 0],
                            [0, 0, 0, 0, 0, 0, 0, 1]])

        self.B = 0
        self.H = np.matrix([[1, 0, 0, 0, 0, 0, 0, 0],
                            [0, 1, 0, 0, 0, 0, 0, 0],
                            [0, 0, 1, 0, 0, 0, 0, 0],
                            [0, 0, 0, 1, 0, 0, 0, 0]])

        self.Q = np.matrix([[0.01, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0.01, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0.01, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0.01, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0.01, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0.01, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0.01, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0.01]]) 

        self.R = np.matrix([[rssi1_std_meas, 0, 0, 0],
                            [0, rssi2_std_meas, 0, 0],
                            [0, 0, rssi3_std_meas, 0],
                            [0, 0, 0, rssi4_std_meas]])
        
        self.P = np.eye(self.A.shape[1])

    def predict(self,z):
        self.x = np.dot(self.A, self.x) + np.dot(self.B, self.u)

        self.P = np.dot(np.dot(self.A, self.P), self.A.T) + self.Q
        # S = H*P*H'+R
        S = np.dot(self.H, np.dot(self.P, self.H.T)) + self.R
        # Calculate the Kalman Gain
        # K = P * H'* inv(H*P*H'+R)
        K = np.dot(np.dot(self.P, self.H.T), np.linalg.inv(S))  #Eq.(11)
        self.x = np.round(self.x + np.dot(K, (z - np.dot(self.H, self.x))),2)   #Eq.(12)
        I = np.eye(self.H.shape[1])
        # Update error covariance matrix
        self.P = (I - (K * self.H)) * self.P   #Eq.(13)

        
        # return self.x[0:4]
        return np.squeeze(np.asarray(self.x[0:4]))[0]