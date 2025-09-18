using formioCommon.Constants;
using formioHelpers;
using formioModels;
using formioModels.Data;
using formioRepo.DataSourceKeysConfiguration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public class DataSourceKeysConfigurationService : IDataSourceKeysConfigurationService
    {
        private IDataSourceKeysConfigurationRepository _dataSourceKeysConfigurationRepository;
        public DataSourceKeysConfigurationService(IDataSourceKeysConfigurationRepository dataSourceKeysConfigurationRepository)
        {
            _dataSourceKeysConfigurationRepository = dataSourceKeysConfigurationRepository;
        }

        public Guid? ArchiveDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            dataSetUpsertInputModel.CustomApplicationId = _dataSourceKeysConfigurationRepository.ArchiveDataSourceKeysConfiguration(dataSetUpsertInputModel, loggedInContext, validationMessages);

            return dataSetUpsertInputModel.CustomApplicationId;
        }

        public Guid? CreateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            dataSetUpsertInputModel.Id = _dataSourceKeysConfigurationRepository.CreateDataSourceKeysConfiguration(dataSetUpsertInputModel, loggedInContext, validationMessages);

            return dataSetUpsertInputModel.Id;
        }

        public DataSourceKeysConfigurationModel SearchDataSourceKeyConfiguration(DataSourceKeysConfigurationSearchInputModel dataSourceKeysConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            DataSourceKeysConfigurationModel dataSourceKeysConfigurations = _dataSourceKeysConfigurationRepository.SearchDataSourceKeysConfiguration(dataSourceKeysConfigurationSearchInputModel, loggedInContext, validationMessages);

            return dataSourceKeysConfigurations;
        }

        public List<DataSourceKeysConfigurationOutputModel> SearchDataSourceKeysConfigurationAnonymous(DataSourceKeysConfigurationSearchInputModel dataSourceKeysConfigurationSearchInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetService"));

            List<DataSourceKeysConfigurationOutputModel> dataSourceKeysConfigurations = _dataSourceKeysConfigurationRepository.SearchDataSourceKeysConfigurationAnonymous(dataSourceKeysConfigurationSearchInputModel, validationMessages);

            return dataSourceKeysConfigurations;
        }

        public Guid? UpdateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            dataSetUpsertInputModel.CustomApplicationId = _dataSourceKeysConfigurationRepository.UpdateDataSourceKeysConfiguration(dataSetUpsertInputModel, loggedInContext, validationMessages);

            return dataSetUpsertInputModel.CustomApplicationId;
        }
    }
}
