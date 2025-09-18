using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.RecentSearch;
using Btrak.Models.Widgets;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Repositories
{
   public class RecentSearchRepository : BaseRepository
    {
        public Guid? InsertRecentSearch(RecentSearchApiModel search, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", search.Name);
                    vParams.Add("@SearchType", search.recentSearchType);
                    vParams.Add("@ItemId", search.ItemId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRecentSearch, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertRecentSearch", "RecentSearchRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProjectFeatureUpsert);
                return null;
            }
        }

        public RecentSearchModel[] GetRecentSearch(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RecentSearchModel>(StoredProcedureConstants.SpGetRecentSearch, vParams, commandType: CommandType.StoredProcedure).ToArray();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRecentSearch", "RecentSearchRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProjectFeatureUpsert);
                return null;
            }
        }

        public List<WidgetApiReturnModel> GetRecentSearchedApps(WidgetSearchCriteriaInputModel widgetSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", widgetSearchCriteriaInput.SearchText);
                    vParams.Add("@SearchTag", widgetSearchCriteriaInput.Tags);
                    vParams.Add("@PageNumber", widgetSearchCriteriaInput.PageNumber);
                    vParams.Add("@PageSize", widgetSearchCriteriaInput.PageSize);
                    vParams.Add("@SortBy", widgetSearchCriteriaInput.SortBy);
                    vParams.Add("@SortDirection", widgetSearchCriteriaInput.SortDirection);
                    vParams.Add("@TagId", widgetSearchCriteriaInput.TagId);
                    vParams.Add("@IsFromSearch", widgetSearchCriteriaInput.IsFromSearch);
                    vParams.Add("@IsFavouriteWidget", widgetSearchCriteriaInput.IsFavouriteWidget);
                    return vConn.Query<WidgetApiReturnModel>(StoredProcedureConstants.SpGetRecentSearchedApps, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRecentSearchedApps", "RecentSearchRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProjectFeatureUpsert);
                return null;
            }
        }

        public SearchTasksModel[] SearchGoalTasks(string SearchTask, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", SearchTask);
                    return vConn.Query<SearchTasksModel>(StoredProcedureConstants.SpGetSearchGoalTasks, vParams, commandType: CommandType.StoredProcedure).ToArray();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchGoalTasks", "RecentSearchRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProjectFeatureUpsert);
                return null;
            }
        }

        public List<SearchItemsOutputModel> GetSearchMenuItems(SearchItemsInputModel searchItemsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", searchItemsInputModel.SearchText);
                    vParams.Add("@SearchUniqueId", searchItemsInputModel.SearchUniqueId);
                    return vConn.Query<SearchItemsOutputModel>(StoredProcedureConstants.SpGetSearchMenuItems, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSearchMenuItems", "RecentSearchRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMenuSearchItems);
                return null;
            }
        }

    }
}
