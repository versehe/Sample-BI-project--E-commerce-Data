''' import modules '''
import pandas as pd
import numpy as np


''' import data files '''
sale = pd.read_csv(r'C:\Users\verse\Desktop\Earnin_Zhong_He\Assessment_Data\sale.csv')


'''
Questions: statistical test on sales distribution, if the weekly sale change is in confidence interval?

H0: weekly sale change are in normal range
H1: weekly sale change are not in normal range


confidence level : 95%
 
'''
sale['created_on'] = pd.to_datetime(sale['created_on']) 
# get the weekly sale amount
weekly_sale = sale.groupby([pd.Grouper(key='created_on', freq='W-MON')])['amount'].sum().reset_index().sort_values('created_on')
# filter to last 3 year data, last week only contains a few days, it's unfair to compare with entire weeks
weekly_sale = weekly_sale[(weekly_sale['created_on']>='2/16/2015') & (weekly_sale['created_on']<'2/27/2017')]
# get the weekly sale difference
weekly_sale['weekly_diff'] =   weekly_sale['amount'] - weekly_sale['amount'].shift(1)

#  check the distribution of this difference
import matplotlib.pyplot as plt
plt.hist(weekly_sale['weekly_diff'][2:], bins = 10) # normal distribution

# get the t test for weekly sale difference
import math 
mean = weekly_sale['weekly_diff'].sum() / weekly_sale['weekly_diff'].count()
standard_error =   math.sqrt(np.var(weekly_sale['weekly_diff']) / weekly_sale['weekly_diff'].count())
margin_of_error = 1.96 * standard_error
upper_bound = mean + margin_of_error
lower_bound = mean - margin_of_error

# check if the last weekly sale difference is in the range
print( (weekly_sale['weekly_diff'].iloc[-1] >= lower_bound) & (weekly_sale['weekly_diff'].iloc[-1] <= upper_bound))
# false

'''
Conclusion: the weekly sale difference for last week
is out of confidence interval bound, reject null hypothsis,
the weekly sale decrease are indeed lower than expecation
'''
