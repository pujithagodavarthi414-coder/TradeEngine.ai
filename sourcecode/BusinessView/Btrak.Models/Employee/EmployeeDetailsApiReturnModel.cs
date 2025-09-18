using Btrak.Models.PayRoll;
using System.Collections.Generic;

namespace Btrak.Models.Employee
{
    public class EmployeeDetailsApiReturnModel
    {
        public EmployeeDetailsApiReturnModel()
        {
            var employeeEducationDetails = new List<EmployeeEducationDetailsApiReturnModel>();
            var employeeEmergencyContactDetails = new List<EmployeeEmergencyContactDetailsApiReturnModel>();
            var employeeImmigrationDetails = new List<EmployeeImmigrationDetailsApiReturnModel>();
            var employeeJobDetails = new List<EmployeeJobDetailsApiReturnModel>();
            var employeeLanguageDetails = new List<EmployeeLanguageDetailsApiReturnModel>();
            var employeeLicenceDetails = new List<EmployeeLicenceDetailsApiReturnModel>();
            var employeePersonalDetails = new List<EmployeePersonalDetailsApiReturnModel>();
            var employeeReportToDetails = new List<EmployeeReportToDetailsApiReturnModel>();
            var employeeSalaryDetails = new List<EmployeeSalaryDetailsApiReturnModel>();
            var employeeSkillDetails = new List<EmployeeSkillDetailsApiReturnModel>();
            var employeeWorkExperienceDetails = new List<EmployeeWorkExperienceDetailsApiReturnModel>();
            var employmentContractDetails = new List<EmploymentContractDetailsApiReturnModel>();
            var employeeMembershipDetails = new List<EmployeeMembershipDetailsApiReturnModel>();
            var employeeContactDetails = new List<EmployeeContactDetailsApiReturnModel>();
            var employeeRateSheetDetails = new List<EmployeeRateSheetDetailsApiReturnModel>();
            var employeeRateTagDetails = new List<EmployeeRateTagDetailsApiReturnModel>();
        }

        public List<EmployeeEducationDetailsApiReturnModel> employeeEducationDetails { get; set; }
        public List<EmployeeEmergencyContactDetailsApiReturnModel> employeeEmergencyContactDetails { get; set; }
        public List<EmployeeImmigrationDetailsApiReturnModel> employeeImmigrationDetails { get; set; }
        public List<EmployeeJobDetailsApiReturnModel> employeeJobDetails { get; set; }
        public List<EmployeeLanguageDetailsApiReturnModel> employeeLanguageDetails { get; set; }
        public List<EmployeeLicenceDetailsApiReturnModel> employeeLicenceDetails { get; set; }
        public List<EmployeePersonalDetailsApiReturnModel> employeePersonalDetails { get; set; }
        public List<EmployeeReportToDetailsApiReturnModel> employeeReportToDetails { get; set; }
        public List<EmployeeSalaryDetailsApiReturnModel> employeeSalaryDetails { get; set; }
        public List<EmployeeSkillDetailsApiReturnModel> employeeSkillDetails { get; set; }
        public List<EmployeeWorkExperienceDetailsApiReturnModel> employeeWorkExperienceDetails { get; set; }
        public List<EmploymentContractDetailsApiReturnModel> employmentContractDetails { get; set; }
        public List<EmployeeMembershipDetailsApiReturnModel> employeeMembershipDetails { get; set; }
        public List<EmployeeContactDetailsApiReturnModel> employeeContactDetails { get; set; }
        public List<EmployeeRateSheetDetailsApiReturnModel> employeeRateSheetDetails { get; set; }
        public List<EmployeeRateTagDetailsApiReturnModel> employeeRateTagDetails { get; set; }
    }
}
