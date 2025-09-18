using System;
using System.Collections.Generic;

namespace Btrak.Models.PayRoll
{
    public class EmployeeSalaryCertificateModel
    {

        public EmployeeSalaryCertificateModel()
        {
            BranchesList = new List<BranchModel>();
            DesignationsList = new List<DesignationsModel>();
            RolesList = new List<RoleModel>();
            BonusesList = new List<BonusModel>();
            PaySlipsList = new List<PaySlipModel>();
            SalaryHikesList = new List<SalaryHikesModel>();
            SalaryBreakDownRecordsList = new List<SalaryBreakDownModel>();
        }

        public string EmployeeName { get; set; }
        public string EmployeeNumber { get; set; }
        public DateTime? JoiningDate { get; set; }
        public string NetPayAmount { get; set; }
        public string CompanyName { get; set; }
        public string HeadOfficeAddress { get; set; }
        public string CompanySiteAddress { get; set; }
        public string HRManagerName { get; set; }
        public string HRManagerEmail { get; set; }
        public string HRManagerMobileNo { get; set; }
        public string CompanyEmail { get; set; }
        public string StartingSalary { get; set; }
        public string CurrencySymbol { get; set; }
        public string SalaryBreakDownDate { get; set; }
        public string CompanyPhoneNumber { get; set; }
        


        public string SalaryHikes { get; set; }
        public string SalaryBreakDownRecords { get; set; }
        public string Branches { get; set; }
        public string Designations { get; set; }
        public string Roles { get; set; }
        public string Bonuses { get; set; }
        public string PaySlips { get; set; }
        public string CompanyLogo { get; set; }

        public List<BranchModel> BranchesList { get; set; }
        public List<DesignationsModel> DesignationsList { get; set; }
        public List<RoleModel> RolesList { get; set; }
        public List<BonusModel> BonusesList { get; set; }
        public List<PaySlipModel> PaySlipsList { get; set; }
        public List<SalaryHikesModel> SalaryHikesList { get; set; }
        public List<SalaryBreakDownModel> SalaryBreakDownRecordsList { get; set; }
    }


    public class BranchModel
    {
        public string BranchName { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
    }

    public class DesignationsModel
    {
        public string DesignationName { get; set; }
    }

    public class RoleModel
    {
        public string RoleName { get; set; }
    }

    public class BonusModel
    {
        public string PayRollMonth { get; set; }
        public string Bonus { get; set; }
    }

    public class PaySlipModel
    {
        public string PayRollMonth { get; set; }
        public DateTime? PayRollStartDate { get; set; }
        public DateTime? PayRollEndDate { get; set; }
        public string NetAmount { get; set; }
    }

    public class SalaryHikesModel
    {
        public string CTC { get; set; }
        public string VariablePay { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
    }

    public class SalaryBreakDownModel
    {
        public string ComponentName { get; set; }
        public string ActualNetPayAmount { get; set; }
        public string ActualComponentAmount { get; set; }
        public bool IsDeduction { get; set; }
        public DateTime? PayrollStartDate { get; set; }
        public DateTime? PayrollEndDate { get; set; }
    }

}
