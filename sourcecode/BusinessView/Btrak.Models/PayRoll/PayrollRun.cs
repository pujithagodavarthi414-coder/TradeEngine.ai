using System;
using System.Collections.Generic;
using Btrak.Models.GenericForm;

namespace Btrak.Models.PayRoll
{
   public class PayrollRun
    {
        public PayrollRun()
        {
            EmployeeDetailsList = new List<PayrollRunOutPutModel>();
        }

        public Guid? Id { get; set; }
        public DateTime? RunDate { get; set; }
        public string BankSubmittedFilePointer { get; set; }
        public DateTime? PayrollStartDate { get; set; }
        public DateTime? PayrollEndDate { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? TemplateId { get; set; }
        public Guid? PayrollStatusId { get; set; }
        public Guid? WorkflowProcessInstanceId { get; set; }
        public UserTasksModel UserTasks { get; set; }
        public string Comments { get; set; }
        public string PayrollStatusName { get; set; }
        public bool IsPayslipReleased { get; set; }
        public string BranchName { get; set; }
        public List<Guid> EmploymentStatusIds { get; set; }
        public string EmploymentStatusIdsList { get; set; }
        public List<Guid> EmployeeIds  { get; set; }
        public string EmployeeIdsList { get; set; }
        public string EmploymentStatusNames { get; set; }
        public string EmployeeNames { get; set; }
        public string TemplateName { get; set; }
        public List<PayrollRunOutPutModel> EmployeeDetailsList { get; set; }
        public string EmployeeDetails { get; set; }
        public string PayRollStatusColour { get; set; }
        public string EmployeesList { get; set; }
        public List<EmployeeListModel> PayRollRunEmployees { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime? ChequeDate { get; set; }
        public string AlphaCode { get; set; }
        public string Cheque { get; set; }
        public string ChequeNo { get; set; }
    }

    public class EmployeeListModel
    {
        public string UserName { get; set; }
        public string ProfileImage { get; set; }
        public Guid? UserId { get; set; }
        public string RoleName { get; set; }
    }
}
