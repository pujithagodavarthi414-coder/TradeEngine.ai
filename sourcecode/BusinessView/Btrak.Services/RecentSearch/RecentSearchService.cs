using System;
using System.Collections.Generic;
using BTrak.Common;
using Btrak.Models;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.Helpers;
using Btrak.Models.RecentSearch;
using Btrak.Models.Widgets;
using System.Linq;
using Btrak.Dapper.Dal.Partial;
using System.Configuration;

namespace Btrak.Services.RecentSearch
{
    public class RecentSearchService : IRecentSearch
    {
        private readonly RecentSearchRepository _residentSearchReposistory;
        private readonly MenuItemRepository _menuItemRepository = new MenuItemRepository();
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();

        public RecentSearchService(RecentSearchRepository residentSearchReposistory)
        {
            this._residentSearchReposistory = residentSearchReposistory;
        }

        public Guid? InsertRecentSearch(RecentSearchApiModel search, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertRecentSearch", "Recent Search Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            return _residentSearchReposistory.InsertRecentSearch(search,loggedInContext,validationMessages);
        }

        public RecentSearchModel[] GetRecentSearch(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRecentSearch", "Recent Search Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            return _residentSearchReposistory.GetRecentSearch(loggedInContext, validationMessages);
        }

        public List<WidgetApiReturnModel> GetRecentSearchedApps(WidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRecentSearchedApps", "Recent Search Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            return _residentSearchReposistory.GetRecentSearchedApps(widgetSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public SearchTasksModel[] SearchGoalTasks(string SearchTask, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchGoalTasks", "Recent Search Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            return _residentSearchReposistory.SearchGoalTasks(SearchTask, loggedInContext, validationMessages);
        }

        public SearchMenuDataModel GetSearchMenuData(bool getDashboards, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSearchMenuData", "Recent Search Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            WidgetSearchCriteriaInputModel widget = new WidgetSearchCriteriaInputModel();
            widget.IsArchived = false;
            widget.PageNumber = 1;
            widget.PageSize = 16;
            widget.SortDirectionAsc = true;
            widget.WidgetId = null;
            widget.IsFavouriteWidget = true;
            WorkspaceSearchCriteriaInputModel workspace = new WorkspaceSearchCriteriaInputModel()
            {
                IsHidden = false,
                WorkspaceId = null
            };
            SearchMenuDataModel searchData = new SearchMenuDataModel();
            var MenuCategory = "Main";
            searchData.MenuItems = _menuItemRepository.GetAllApplicableMenuItems(loggedInContext, validationMessages, MenuCategory).ToList();
            var isForTrading = ConfigurationManager.AppSettings["IsTradingModule"];
            if(isForTrading == "true")
            {
                var tradingModules = ConfigurationManager.AppSettings["AppliedModulesInTrading"]?.Split(',');
                searchData.MenuItems = searchData.MenuItems.Where(x => tradingModules.Contains(x.Menu) == true).ToList();
            }
            searchData.Widgets = _widgetRepository.GetWidgetsBasedOnUser(widget, loggedInContext, validationMessages);
            if(getDashboards)
            {
                searchData.Workspaces = _widgetRepository.GetWorkspaces(workspace, loggedInContext, validationMessages);
            }
            searchData.RecentSearch = GetRecentSearch(loggedInContext, validationMessages).ToList();
            
            return searchData;
        }

        public List<SearchItemsOutputModel> GetSearchMenuItems(SearchItemsInputModel searchItemsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSearchMenuItems", "Recent Search Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            return _residentSearchReposistory.GetSearchMenuItems(searchItemsInputModel, loggedInContext, validationMessages);
        }
    }
}
