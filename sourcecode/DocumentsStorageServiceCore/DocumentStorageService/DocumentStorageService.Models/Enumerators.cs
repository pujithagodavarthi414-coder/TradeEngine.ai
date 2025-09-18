using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models
{
    public class Enumerators
    {
        public enum ModuleTypeEnum
        {
            Hrm = 1,
            Assets = 2,
            FoodOrder = 3,
            Projects = 4,
            Cron = 5,
            Invoices = 6,
            Expenses = 7,
            TestRepo = 8,
            CompanyStructure = 9,
            Scripts = 10,
            Audits = 11,
            Conducts = 12
        }

        public enum FileTypeEnum
        {
            HrmFiles = 1,
            AssetsFiles = 2,
            FoodOrderFiles = 3,
            ProjectFiles = 4,
            CustomFiles = 5,
            TestSuiteFiles = 6,
            TestCaseFiles = 7,
            HtmlAppFiles = 8,
            CustomDocFiles = 9,
            ExpensesFiles = 10,
            InvoiceFiles = 11,
            PayRoll = 12,
            signature = 13,
            AuditFiles = 14,
            RecruitmentFiles = 15
        }
    }
}
