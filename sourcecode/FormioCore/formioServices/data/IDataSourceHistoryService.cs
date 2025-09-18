using formioModels;
using formioModels.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
   public interface IDataSourceHistoryService
    {
        Guid? CreateDataSourceHistory(DataSourceHistoryInputModel dataSourceHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSourceHistoryOutputModel> SearchDataSourceHistory(DataSourceHistorySearchInputModel dataSourceHistorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
