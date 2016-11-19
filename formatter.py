import argparse
import datetime as dt;
parser = argparse.ArgumentParser(description='This module will parse pull request and commit history for openmrs repositories and return monthly statistics')
parser.add_argument('-p','--pulls', help="pull request dates as json", required=True)
args = parser.parse_args()
dates = args.pulls.replace("\"","").split()
dates_list = [dt.datetime.strptime(date, '%Y-%m-%dT%H:%M:%SZ').date() for date in dates]
print(dates_list)
