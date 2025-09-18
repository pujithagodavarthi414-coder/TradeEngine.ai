using formioModels;
using formioModels.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public interface IDataSourceKeysService
    {
        Guid? CreateDataSourceKeys(DataSourceKeysInputModel dataSetUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateDataSourceKeys(DataSourceKeysInputModel dataSetUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSourceKeysOutputModel> SearchDataSourceKeys(DataSourceKeysSearchInputModel dataSourceKeysSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSourceKeysOutputModel> SearchDataSourceKeysAnonymous(DataSourceKeysSearchInputModel dataSourceKeysSearchInputModel, List<ValidationMessage> validationMessages);
        Guid? CreateOrUpdateQunatityDetails(CreateOrUpdateQunatityInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
