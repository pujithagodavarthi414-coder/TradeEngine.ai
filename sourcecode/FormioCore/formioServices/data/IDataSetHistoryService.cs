using formioModels;
using formioModels.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
   public interface IDataSetHistoryService
    {
        Guid? CreateDataSetHistory(DataSetHistoryInputModel dataSetHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSetHistoryInputModel> SearchDataSetHistory(Guid? dataSetId,Guid? referenceId, int? pageNo, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
