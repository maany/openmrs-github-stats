import argparse
import datetime as dt
from dateutil import relativedelta as rdelta

parser = argparse.ArgumentParser(description='This module will parse pull request and commit history for openmrs repositories and return monthly statistics')
parser.add_argument('-p','--pulls', help="pull request dates as json", required=True)
args = parser.parse_args()
dates = args.pulls.replace("\"","").split()
dates_list = [dt.datetime.strptime(date, '%Y-%m-%dT%H:%M:%SZ').date() for date in dates]
# print(dates_list)
reference = dt.date(2015,11,1)

pr_list = [0] * 12
pr_list = [0 for i in xrange(12)]


for date in dates_list:
    rd = rdelta.relativedelta(date,reference)
    if rd.years ==0 and rd.months>=0:
        pr_list[rd.months] += 1
    #print "{0.years} years and {0.months} months".format(rd)
if not pr_list :
    print("[]")
else :
    print(pr_list)
