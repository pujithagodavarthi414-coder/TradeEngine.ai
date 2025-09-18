using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Models.Roster;
using Btrak.Models.TimeSheet;
using Btrak.Models.User;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Btrak.Services.Roster.RosterService;

namespace Btrak.Services.Roster
{
    public interface IRosterService
    {
        List<RosterPlanSolution> CreateRosterSolutions(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CreateRosterPlan(RosterPlanInputModel rosterPlanInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string url);
        List<RosterSearchOutputModel> GetRosterPlans(RosterSearchInputModel rosterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RosterPlanOutputModel> GetRosterPlanByRequest(RosterSearchInputModel rosterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        RosterPlanSolutionOutput GetRosterSolutionsById(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CheckRosterName(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RosterTemplatePlanOutputModel> GetRosterTemplatePlanByRequest(RosterSearchInputModel rosterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool? SendTimesheetEmployeeManagerMails(string statusName, TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel,
            List<UserOutputModel> userDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RosterPlan> LoadShiftwiseEmployeeForRoster(ShiftWiseEmployeeRosterInputModel shiftWiseEmployeeRosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool? SendFinishMailToEmployee(TimeSheetManagementInputModel timeSheetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RosterEmployeeRatesOutput> GetEmployeeRatesFromRateTags(RosterEmployeeRatesInput rosterEmployeeRatesInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
