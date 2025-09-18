using formioCommon.Constants;
using formioHelpers.Data;
using formioHelpers;
using formioModels.Data;
using formioModels;
using formioRepo.DataLevelKeyConfiguration;
using formioRepo.DataSetHistory;
using MongoDB.Bson;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public class DataLevelKeyConfigurationService : IDataLevelKeyConfigurationService
    {
        private readonly IDataLevelKeyConfigurationRepository _dataLevelKeyConfigurationRepository;
        public DataLevelKeyConfigurationService(IDataLevelKeyConfigurationRepository dataLevelKeyConfigurationRepository)
        {
            _dataLevelKeyConfigurationRepository = dataLevelKeyConfigurationRepository;
        }
        public Guid? CreateLevelKeyConfiguration(DataLevelKeyConfigurationModel dataLevelKeyConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (dataLevelKeyConfigurationModel.Id == null)
            {
                dataLevelKeyConfigurationModel.Id = _dataLevelKeyConfigurationRepository.CreateLevelKeyConfiguration(dataLevelKeyConfigurationModel, loggedInContext, validationMessages);
            }
            else if (dataLevelKeyConfigurationModel.Id != null && dataLevelKeyConfigurationModel.Id != Guid.Empty)
            {
                dataLevelKeyConfigurationModel.Id = _dataLevelKeyConfigurationRepository.UpdateLevelKeyConfiguration(dataLevelKeyConfigurationModel, loggedInContext, validationMessages);
            }

            return dataLevelKeyConfigurationModel.Id;
        }
        public List<GetDataLevelKeyConfigurationModel> SearchLevelKeyConfiguration(Guid? customApplicationId, Guid? levelId,bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<GetDataLevelKeyConfigurationModel> dataLevelKeyConfigurationModelList = _dataLevelKeyConfigurationRepository.SearchLevelKeyConfiguration(customApplicationId, levelId, isArchived, loggedInContext, validationMessages);
            return dataLevelKeyConfigurationModelList;
        }
    }
}