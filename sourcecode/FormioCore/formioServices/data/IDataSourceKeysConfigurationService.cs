using formioModels;
using formioModels.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public interface IDataSourceKeysConfigurationService
    {
        Guid? CreateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        DataSourceKeysConfigurationModel SearchDataSourceKeyConfiguration(DataSourceKeysConfigurationSearchInputModel dataSourceKeysConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<DataSourceKeysConfigurationOutputModel> SearchDataSourceKeysConfigurationAnonymous(DataSourceKeysConfigurationSearchInputModel dataSourceKeysConfigurationSearchInputModel, List<ValidationMessage> validationMessages);
    }
}
