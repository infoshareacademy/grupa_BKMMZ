import numpy as np

def stats(dataframe) :
    """Returns informations about dataset - shape and data types"""
    print('### Shape ###')
    print(f'Rows: {dataframe.shape[0]}')
    print(f'Columns: {dataframe.shape[1]}')
    print('\n')
    print('### Data Types ###')
    print(dataframe.dtypes)
    print('\n')

def miss_dupl(dataframe) :
    """Return information about missing values and duplicates in dataset"""
    print('\n')
    print('### Missing Values ###')
    ndf = dataframe.isna().sum()
    print(ndf[ndf > 0])
    print('\n')
    print('### Duplicate Values ###')
    print(dataframe.duplicated().sum())
    print('\n')
    print('### Unique Values ###')
    print(dataframe.nunique().sum())

def columns_bsize(dataframe) :
    """ Return size of each column in bytes"""
    return [f'{x} --- {dataframe[x].nbytes} --- {dataframe[x].dtype}' for x in dataframe]

def change_to_int(dataframe, list) :
    """ Change given columns type to int16"""
    for x in list:
        dataframe[x] = dataframe[x].astype('int16')

def drop_missing_five(dataframe) :
    """ Return infrmation which column is in drop treshold of 5% missing values"""
    tresh = int(len(dataframe) * 0.05)
    return dataframe.columns[dataframe.isna().sum() <= tresh]

def dataset_IQR(col) :
    """ Calculate IQR for given column """
    return np.quantile(col, 0.75) - np.quantile(col, 0.25)

def lower_tresh(col):
   """ Calculate lower treshold """ 
   return np.quantile(col, 0.25) - (1.5 * dataset_IQR(col))

def upper_tresh(col) :
    """ Calculate upper treshold """
    return np.quantile(col, 0.75) + (1.5 * dataset_IQR(col))

def lower_treshholders(dataframe) :
    for x in dataframe.select_dtypes(include= 'number') :
        print(f'Column: {x}')
        print(f'Lower treshold {lower_tresh(dataframe[x])}')
        print(f'Ilosc wartosci ponizej dolnego outlinera: {dataframe[x][dataframe[x] < lower_tresh(dataframe[x])].count()}\n')

def upper_treshholders(dataframe) :
    for x in dataframe.select_dtypes(include= 'number') :
        print(f'Column: {x}')
        print(f'Upper treshold {upper_tresh(dataframe[x])}')
        print(f'Ilosc wartosci powyzej górnego outlinera: {dataframe[x][dataframe[x] > upper_tresh(dataframe[x])].count()}\n')

def remove_outliners(dataframe) :
    for x in dataframe.select_dtypes(include= 'number') :
        dataframe = dataframe[(dataframe[x] >= lower_tresh(dataframe[x])) & (dataframe[x] <= upper_tresh(dataframe[x]))]
    return dataframe