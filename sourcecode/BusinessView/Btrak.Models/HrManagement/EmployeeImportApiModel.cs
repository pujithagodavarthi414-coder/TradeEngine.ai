using System.Collections.Generic;

namespace Btrak.Models.HrManagement
{
    public class EmployeeImportApiModel
    {
        public string EmployeeNumber { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string EmailId { get; set; }
        public string MobileNumber { get; set; }
        public string Role { get; set; }
        public string Designation { get; set; }
        public string EmploymentType { get; set; }
        public string BranchJoining { get; set; }
        public string Date { get; set; }
        public string Timezone { get; set; }
        public string CTCPayroll { get; set; }
        public string Template { get; set; }
        public List<EmployeeExcelPair> EmployeeKeyValuePairs { get; set; }
        public class EmployeeExcelPair
        {
            public string Key { get; set; }

            public string Value { get; set; }
        }
    }
}
