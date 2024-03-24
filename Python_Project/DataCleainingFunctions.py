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
    print(dataframe.isna().sum())
    print('\n')
    print('### Duplicate Values ###')
    print(dataframe.duplicated().sum())
    print('\n')
    print('### Unique Values ###')
    print(dataframe.nunique().sum())

def drop_treshold(dataframe) :
    """ Return infrmation which column is in drop treshold of 5% missing values"""
    tresh = int(len(dataframe) * 0.05)
    return dataframe.columns[dataframe.isna().sum() <= tresh]