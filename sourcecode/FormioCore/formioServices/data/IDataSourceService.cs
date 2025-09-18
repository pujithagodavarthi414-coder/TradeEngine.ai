using formioModels;
using System;
using System.Collections.Generic;
using formioModels.Data;
using System.Threading.Tasks;
using formioCommon.Constants;

namespace formioServices.Data
{
    public interface IDataSourceService
    {
       Guid? CreateDataSource(DataSourceFakeInputModel dataSourceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
       Guid? UpdateDataSource(DataSourceFakeInputModel dataSourceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSourceOutputModel> SearchDataSource(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
         List<DataSourceOutputModel> SearchDataSourceUnAuth(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel,
            List<ValidationMessage> validationMessages);

        List<DataSourceOutputModel> SearchDataSourceForJob(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel,
            List<ValidationMessage> validationMessages);
        List<SearchDataSourceOutputModel> SearchAllDataSources(SearchDataSourceInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetDataSourcesByIdOutputModel> GetDataSourcesById(GetDataSourcesByIdInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GenericQueryApi(string inputQuery, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        GetFormFieldValuesOutputModel GetFormFieldValues(GetFormFieldValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetFormRecordValues(GetFormRecordValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string BackgroundLookupLink(Guid customApplicationId, Guid formId, string companyIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isNotificationNeeded = true);
        List<NotificationModel> GetNotifications(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> UpsertReadNewNotifications(NotificationReadModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void UpdateLookupChildDataWithNewVar(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
