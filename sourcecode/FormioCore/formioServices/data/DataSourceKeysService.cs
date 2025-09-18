using formioCommon.Constants;
using formioHelpers;
using formioModels;
using formioModels.Data;
using formioRepo.DataSourceKeys;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public class DataSourceKeysService : IDataSourceKeysService
    {
        private readonly IDataSourceKeysRepository _dataSourceKeysRepository;
        public DataSourceKeysService(IDataSourceKeysRepository dataSourceKeysRepository)
        {
            _dataSourceKeysRepository = dataSourceKeysRepository;
        }
        public Guid? CreateDataSourceKeys(DataSourceKeysInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            dataSetUpsertInputModel.Id = _dataSourceKeysRepository.CreateDataSourceKeys(dataSetUpsertInputModel, loggedInContext, validationMessages);
            
            return dataSetUpsertInputModel.Id;
        }

        public List<DataSourceKeysOutputModel> SearchDataSourceKeys(DataSourceKeysSearchInputModel dataSourceKeysSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<DataSourceKeysOutputModel> dataSourceKeys = _dataSourceKeysRepository.SearchDataSourceKeys(dataSourceKeysSearchInputModel, loggedInContext, validationMessages);

            return dataSourceKeys;
        }

        public List<DataSourceKeysOutputModel> SearchDataSourceKeysAnonymous(DataSourceKeysSearchInputModel dataSourceKeysSearchInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceKeysAnonymous", "DataSetService"));

            List<DataSourceKeysOutputModel> dataSourceKeys = _dataSourceKeysRepository.SearchDataSourceKeysAnonymous(dataSourceKeysSearchInputModel, validationMessages);

            return dataSourceKeys;
        }

        public Guid? UpdateDataSourceKeys(DataSourceKeysInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            dataSetUpsertInputModel.Id = _dataSourceKeysRepository.UpdateDataSourceKeys(dataSetUpsertInputModel, loggedInContext, validationMessages);

            return dataSetUpsertInputModel.Id;
        }
        public Guid? CreateOrUpdateQunatityDetails(CreateOrUpdateQunatityInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateOrUpdateQunatityDetails", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            inputModel.Id = _dataSourceKeysRepository.CreateOrUpdateQunatityDetails(inputModel, loggedInContext, validationMessages);

            return inputModel.Id;
        }
    }
}
