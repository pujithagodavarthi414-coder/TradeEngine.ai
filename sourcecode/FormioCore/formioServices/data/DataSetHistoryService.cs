using formioCommon.Constants;
using formioHelpers;
using formioModels;
using formioModels.Data;
using formioRepo.DataSetHistory;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public class DataSetHistoryService : IDataSetHistoryService
    {
        private readonly IDataSetHistoryRepository _dataSetHistoryRepository;
        public DataSetHistoryService(IDataSetHistoryRepository dataSetHistoryRepository)
        {
            _dataSetHistoryRepository = dataSetHistoryRepository;
        }
        public Guid? CreateDataSetHistory(DataSetHistoryInputModel dataSetHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSetHistory", "DataSetHistoryService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? Id = _dataSetHistoryRepository.CreateDataSetHistory(dataSetHistoryInputModel, loggedInContext, validationMessages);
            return Id;
        }
        public List<DataSetHistoryInputModel> SearchDataSetHistory(Guid? dataSetId, Guid? referenceId,int? pageNo, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSetHistory", "DataSetHistoryService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<DataSetHistoryInputModel> history = _dataSetHistoryRepository.SearchDataSetHistory(dataSetId, referenceId,pageNo,pageSize, loggedInContext, validationMessages);
            return history;
        }
    }
}
