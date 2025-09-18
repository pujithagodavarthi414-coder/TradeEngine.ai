using Btrak.Models;
using Btrak.Models.FormDataServices;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.FormDataServices
{
   public interface IDataSourceHistoryService
    {
        Task<Guid> CreateDataSourceHistory(DataSourceHistoryInputModel dataSourceHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<DataSourceHistoryOutputModel>> SearchDataSourceHistory(Guid? id, Guid? dataSourceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
