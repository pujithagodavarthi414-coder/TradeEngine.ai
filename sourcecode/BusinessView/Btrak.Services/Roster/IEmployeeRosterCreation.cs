using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using Btrak.Models.Roster;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Roster
{
    public interface IEmployeeRosterCreation
    {
        List<EmployeeBudget> GetBudgetForEachEmployee(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, Dictionary<Guid, int> employeeCounter);
        List<EmployeeOutputModel> LoadEmployeeDetails(Guid? BranchId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeRateSheetDetailsApiReturnModel> LoadRatesheetForAllEmployee(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ShiftWeekSearchOutputModel> GetShiftWeekData(Guid shiftTimingId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
