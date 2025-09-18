using System;
using Btrak.Models;
using BTrak.Common;
using System.Collections.Generic;
using Btrak.Models.Branch;
using Btrak.Models.Employee;

namespace Btrak.Services.Branch
{
    public interface IBranchService
    {
        Guid? UpsertBranch(BranchUpsertInputModel branchUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BranchApiReturnModel> GetAllBranches(BranchSearchInputModel branchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeOutputModel GetUserBranchDetails(EmployeeInputModel userInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BranchApiDropdownReturnModel> GetAllBranchesDropdown(BranchSearchInputModel branchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
