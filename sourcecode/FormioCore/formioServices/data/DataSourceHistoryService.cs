using formioCommon.Constants;
using formioModels;
using formioModels.Data;
using formioRepo.DataSourceHistory;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public class DataSourceHistoryService : IDataSourceHistoryService
    {
        private readonly IDataSourceHistoryRepository _dataSourceHistoryRepository;
        public DataSourceHistoryService(IDataSourceHistoryRepository dataSourceHistoryRepository)
        {
            _dataSourceHistoryRepository = dataSourceHistoryRepository;
        }
        public Guid? CreateDataSourceHistory(DataSourceHistoryInputModel dataSourceHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSource", "DataSourceService"));
            LoggingManager.Debug(dataSourceHistoryInputModel.ToString());

            
            var id = _dataSourceHistoryRepository.CreateDataSourceHistory(dataSourceHistoryInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug(id.ToString());
            return id;
        }

        public List<DataSourceHistoryOutputModel> SearchDataSourceHistory(DataSourceHistorySearchInputModel dataSourceHistorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceHistory", "DataSourceService"));
            LoggingManager.Debug(dataSourceHistorySearchInputModel.ToString());

            List<DataSourceHistoryOutputModel> dataSourceHistoryModels = _dataSourceHistoryRepository.SearchDataSourceHistory(dataSourceHistorySearchInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug(dataSourceHistoryModels.ToString());
            return dataSourceHistoryModels;
        }
    }
}
