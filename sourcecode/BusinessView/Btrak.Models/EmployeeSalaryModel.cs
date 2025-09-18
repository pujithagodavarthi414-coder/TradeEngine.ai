using System;
using System.ComponentModel.DataAnnotations;

namespace Btrak.Models
{
    public class EmployeeSalaryModel
    {
        public Guid Id
        {
            get;
            set;
        }
        public Guid EmployeeId
        {
            get;
            set;
        }
        public Guid SalaryPayGradeId
        {
            get;
            set;
        }
        public string PayGradeName
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Salary Component is required")]
        public string SalaryComponent
        {
            get;
            set;
        }
        public Guid SalaryPayFrequencyId
        {
            get;
            set;
        }
        public string PayFrequencyType
        {
            get;
            set;
        }
        public Guid CurrencyId
        {
            get;
            set;
        }
        public string CurrencyName
        {
            get;
            set;
        }
        public decimal? Amount
        {
            get;
            set;
        }
        public string Comments
        {
            get;
            set;
        }
        public bool IsAddedDepositDetails
        {
            get;
            set;
        }
       
        public string AccountNumber
        {
            get;
            set;
        }
       
        public Guid? AccountTypeId
        {
            get;
            set;
        }
       
        public string RoutingNumber
        {
            get;
            set;
        }
        public string AccountTypeName
        {
            get;
            set;
        }
        public decimal? DepositedAmount
        {
            get;
            set;
        }
        public DateTime ActiveFrom
        {
            get;
            set;
        }
    }
}
