using formioModels;
using formioModels.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioRepo.DataSourceKeysConfiguration
{
   public interface IDataSourceKeysConfigurationRepository
    {
        Guid? CreateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel,
        LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel,
           LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        DataSourceKeysConfigurationModel SearchDataSourceKeysConfiguration(DataSourceKeysConfigurationSearchInputModel dataSourceKeysConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSourceKeysConfigurationOutputModel> SearchDataSourceKeysConfigurationAnonymous(DataSourceKeysConfigurationSearchInputModel dataSourceKeysSearchInputModel, List<ValidationMessage> validationMessages);
    }
}
