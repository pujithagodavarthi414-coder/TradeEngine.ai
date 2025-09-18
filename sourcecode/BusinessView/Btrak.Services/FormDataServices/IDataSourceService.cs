using Btrak.Models;
using Btrak.Models.CustomApplication;
using Btrak.Models.FormDataServices;
using Btrak.Models.GenericForm;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.FormDataServices
{
    public interface IDataSourceService
    {
        Task<Guid?> CreateDataSource(DataSourceInputModel dataSourceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<Guid> CreateDataSourceKeys(DataSourceKeysInputModel dataSourceKeysInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<Guid> UpdateDataSourceKeys(DataSourceKeysInputModel dataSourceKeysInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<DataSourceOutputModel>> SearchDataSource(Guid? id, string searchText, string paramsJsonModel, bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages, string validCompanies = null, bool isCompanyBased = false);
        Task<List<DataSourceOutputModel>> SearchDataSourceUnAuth(Guid? id, string searchText, string paramsJsonModel, bool? isArchived, List<ValidationMessage> validationmessages, string validCompanies = null, bool isCompanyBased = false);
        Task<List<DataSourceKeysOutputModel>> SearchDataSourceKeys(Guid? id, Guid? dataSourceId, string type, string mongoUrl, string searchText, bool? isOnlyForKeys, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string formIdsString = "");
        Task<List<DataSourceKeysOutputModel>> SearchDataSourceKeysAnonymous(Guid? id, Guid? dataSourceId, string searchText, List<ValidationMessage> validationmessages);
        Task<DataSourceKeysConfiguration> SearchDataSourceKeysConfiguration(Guid? id, Guid? dataSourceId, Guid? dataSourceKeyId, Guid? customApplicationId, bool? isOnlyForKeys, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<DataSourceKeysConfiguration> SearchDataSourceKeysConfigurationAnonymous(Guid? id, Guid? dataSourceId, Guid? dataSourceKeyId, Guid? customApplicationId, List<ValidationMessage> validationMessages);
        Task<Guid> CreateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSourceKeysInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<Guid> UpdateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSourceKeysInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<Guid> ArchiveDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSourceKeysInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<SearchAllDataSourcesOutpuutModel>> SearchAllDataSources(GetFormsWithFieldInputModel getFormRecord, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<GetDataSourcesByIdOutputModel>> GetDataSourcesById(GetDataSourcesByIdInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<UpsertDataLevelKeyConfigurationModel>> SearchLevelKeyConfiguration(Guid? id, Guid? customApplicationId, bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> CreateDataLevelKeysConfiguration(UpsertLevelModel upsertLevelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<DataSourceKeysOutputModel>> GetDataSourceKeys(Guid? id, Guid? dataSourceId, string type, string mongoUrl, string searchText, bool? isOnlyForKeys, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string formIdsString = "");
    }
}
