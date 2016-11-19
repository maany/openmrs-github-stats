import argparse
parser = argparse.ArgumentParser(description='This module will parse pull request and commit history for openmrs repositories and return monthly statistics')
parser.add_argument('-p','--pulls', help="pull request dates as json", required=True)
