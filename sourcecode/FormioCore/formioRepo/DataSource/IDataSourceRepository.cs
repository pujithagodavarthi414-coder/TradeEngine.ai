using formioModels;
using System;
using System.Collections.Generic;
using formioModels.Data;
using System.Threading.Tasks;
using formioCommon.Constants;

namespace formioRepo.DataSource
{
    public interface IDataSourceRepository
    {
        Guid? CreateDataSource(DataSourceInputModel dataSourceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateDataSource(DataSourceInputModel dataSourceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSourceOutputModel> SearchDataSource(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSourceOutputModel> SearchDataSourceUnAuth(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, List<ValidationMessage> validationMessages);

        List<DataSourceOutputModel> SearchDataSourceForJob(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel,  List<ValidationMessage> validationMessages);
        List<SearchDataSourceOutputModel> SearchAllDataSources(SearchDataSourceInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetDataSourcesByIdOutputModel> GetDataSourcesById(GetDataSourcesByIdInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GenericQueryApi(string inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        GetFormFieldValuesOutputModel GetFormFieldValues(GetFormFieldValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetFormRecordValues(GetFormRecordValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        NotificationModel UpsertNotification(NotificationModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<NotificationModel> GetNotifications(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> UpsertReadNewNotifications(NotificationReadModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
