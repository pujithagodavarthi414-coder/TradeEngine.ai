using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Employee
{
    public interface IEmployeeService
    {
        Guid? UpsertEmployee(EmployeeInputModel employeeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeOutputModel GetEmployeeById(Guid? employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeDetailsApiOutputModel> GetAllEmployeesDetails(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeOutputModel> GetAllEmployees(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeListApiOutputModel> GetEmployeesList(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeFieldsModel> GetEmployeeFields(EmployeeFieldsModel employeeFieldsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeFields(EmployeeFieldsModel employeeFieldsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
