using Btrak.Models;
using Btrak.Models.RecentSearch;
using Btrak.Models.Widgets;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.RecentSearch
{
    public interface IRecentSearch
    {
        Guid? InsertRecentSearch(RecentSearchApiModel search, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        RecentSearchModel[] GetRecentSearch(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WidgetApiReturnModel> GetRecentSearchedApps(WidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SearchTasksModel[] SearchGoalTasks(string SearchTask, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SearchMenuDataModel GetSearchMenuData(bool GetDashboards, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SearchItemsOutputModel> GetSearchMenuItems(SearchItemsInputModel searchItemsInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
