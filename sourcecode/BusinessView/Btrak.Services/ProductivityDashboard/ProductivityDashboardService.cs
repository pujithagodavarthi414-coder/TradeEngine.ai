using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Models;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.Audit;
using Btrak.Models.ProductivityDashboard;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.ProductivityDashboard;
using Btrak.Models.MyWork;
using Btrak.Models.TestRail;
using System.Web.Hosting;
using System.IO;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml;
using Btrak.Services.FileUploadDownload;

namespace Btrak.Services.ProductivityDashboard
{
    public class ProductivityDashboardService : IProductivityDashboardService
    {
        private readonly ProductivityDashboardRepository _productivityDashboardRepository;
        private readonly IAuditService _auditService;
        private readonly IFileStoreService _fileStoreService;

        public ProductivityDashboardService(ProductivityDashboardRepository productivityDashboardRepository, IAuditService auditService, IFileStoreService fileStoreService)
        {
            _productivityDashboardRepository = productivityDashboardRepository;
            _auditService = auditService;
            _fileStoreService = fileStoreService;
        }

        public List<ProductivityIndexApiReturnModel> GetProductivityIndexForDevelopers(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProductivityIndexForDevelopers", "ProductivityDashboard Service"));

            LoggingManager.Debug(productivityDashboardSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetProductivityIndexForDevelopersCommandId, productivityDashboardSearchCriteriaInputModel, loggedInContext);

            if (!ProductivityDashboardValidations.ValidateProductivityIndexForDevelopers(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<ProductivityIndexApiReturnModel> employeeProductivityIndex = _productivityDashboardRepository.GetProductivityIndexForDevelopers(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return employeeProductivityIndex;
        }

        public List<UserStoryStatusesApiReturnModel> GetUserStoryStatuses(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoryStatuses", "ProductivityDashboard Service"));

            LoggingManager.Debug(productivityDashboardSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetUserStoryStatusesCommandId, productivityDashboardSearchCriteriaInputModel, loggedInContext);

            if (!ProductivityDashboardValidations.ValidateUserStoryStatuses(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserStoryStatusesApiReturnModel> userStoryStatuses = _productivityDashboardRepository.GetUserStoryStatuses(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return userStoryStatuses;
        }

        public List<TestingAgeApiReturnModel> GetQaPerformance(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQaPerformance", "ProductivityDashboard Service"));

            LoggingManager.Debug(productivityDashboardSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetQaPerformanceCommandId, productivityDashboardSearchCriteriaInputModel, loggedInContext);

            if (!ProductivityDashboardValidations.ValidateQaPerformance(productivityDashboardSearchCriteriaInputModel, loggedInContext,  validationMessages))
            {
                return null;
            }

            List<TestingAgeApiReturnModel> testingAgeDetails = _productivityDashboardRepository.GetQaPerformance(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return testingAgeDetails;
        }

        public List<QaApprovalApiReturnModel> GetUserStoriesWaitingForQaApproval(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQaPerformance", "ProductivityDashboard Service"));

            LoggingManager.Debug(productivityDashboardSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetUserStoriesWaitingForQaApprovalCommandId, productivityDashboardSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, productivityDashboardSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            List<QaApprovalApiReturnModel> qaApprovalUserStories = _productivityDashboardRepository.GetUserStoriesWaitingForQaApproval(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return qaApprovalUserStories;
        }

        public List<ProductivityTargetStatusApiReturnModel> GetEveryDayTargetStatus(Guid? entityId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQaPerformance", "ProductivityDashboard Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ProductivityTargetStatusSpReturnModel> employeeProductivityIndex = _productivityDashboardRepository.GetEveryDayTargetStatus(entityId,loggedInContext, validationMessages).ToList();

            var productivityTargetStatusList = new List<ProductivityTargetStatusApiReturnModel>();

            foreach (ProductivityTargetStatusSpReturnModel index in employeeProductivityIndex)
            {
                string color = string.Empty;

                if (index.ExistingProductivity > index.RequiredProductivity)
                    color = "#008000";
                // ReSharper disable once CompareOfFloatsByEqualityOperator
                else if (index.ExistingProductivity == index.RequiredProductivity)
                    color = "#e8ff43";
                else if (index.ExistingProductivity < index.RequiredProductivity)
                    color = "#ff0000";

                var requiredProductivityTargetStatusModel = new ProductivityTargetStatusApiReturnModel
                {
                    ProductivityValue = index.RequiredProductivity,
                    Color = "#286192"
                };

                var existingProductivityTargetStatusModel = new ProductivityTargetStatusApiReturnModel
                {
                    ProductivityValue = index.ExistingProductivity,
                    Color = color
                };

                productivityTargetStatusList.Add(requiredProductivityTargetStatusModel);

                productivityTargetStatusList.Add(existingProductivityTargetStatusModel);
            }

            return productivityTargetStatusList;
        }

        public List<BugReportApiReturnModel> GetBugReport(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBugReport", "ProductivityDashboard Service"));

            LoggingManager.Debug(productivityDashboardSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetBugReportCommandId, productivityDashboardSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (productivityDashboardSearchCriteriaInputModel.SelectedDate == null)
            {
                productivityDashboardSearchCriteriaInputModel.SelectedDate = DateTime.Now;
            }

            List<BugReportApiReturnModel> bugsList = _productivityDashboardRepository.GetBugReport(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return bugsList;
        }

        public List<EmployeeUserStoriesApiReturnModel> GetEmployeeUserStories(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee UserStories", "ProductivityDashboard Service"));

            LoggingManager.Debug(productivityDashboardSearchCriteriaInputModel.ToString());


            if (!ProductivityDashboardValidations.ValidateEmployeeUserStories(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetEmployeeUserStoriesCommandId, productivityDashboardSearchCriteriaInputModel, loggedInContext);

            List<EmployeeUserStoriesApiReturnModel> userStoryList = _productivityDashboardRepository.GetEmployeeUserStories(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return userStoryList;
        }
        public List<EntityDropDownOutputModel> GetEntityDropDown(string searchText,bool isEmployeeList, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllRolesDropDown", "searchText", searchText, "RoleService"));

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllRolesCommandId, searchText, loggedInContext);

            List<EntityDropDownOutputModel> entities = _productivityDashboardRepository.GetEntityDropDown(searchText,isEmployeeList, loggedInContext, validationMessages).ToList();

            return entities;
        }
        public List<UserHistoricalWorkReportSearchSpOutputModel> GetProductivityIndexUserStoriesForDevelopers(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProductivityIndexForDevelopers", "ProductivityDashboard Service"));

            LoggingManager.Debug(productivityDashboardSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetProductivityIndexForDevelopersCommandId, productivityDashboardSearchCriteriaInputModel, loggedInContext);

            if (!ProductivityDashboardValidations.ValidateProductivityIndexForDevelopers(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserHistoricalWorkReportSearchSpOutputModel> employeeProductivityIndexUserStories = _productivityDashboardRepository.GetProductivityIndexUserStoriesForDevelopers(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return employeeProductivityIndexUserStories;
        }

        public PdfGenerationOutputModel GetProduvtivityIndexDrillDownExcelTemplate(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var details = _productivityDashboardRepository.GetProductivityIndexUserStoriesForDevelopers(productivityDashboardSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            var path = "";
            var path1 = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates");
            var guid = Guid.NewGuid();
            if (path1 != null && productivityDashboardSearchCriteriaInputModel.IndexType != "GrpIndex")
            {
                path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/EmployeeIndexDrillDownTemplate.xlsx");
                var pdfOutputModel = new PdfGenerationOutputModel();
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "EmployeeIndexDrillDownTemplate.xlsx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null)
                    {
                        System.IO.File.Copy(path, docName, true);
                    }

                    LoggingManager.Info("Created a directory to save temp file");
                }
                using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                {
                    uint rowIndex = 1;
                    foreach (var detail in details)
                    {
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "A", detail.UserStoryName);
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "B", detail.UserStoryUniqueName);
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "C", detail.GoalName);
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "D", detail.SprintName);
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "E", detail.ProjectName);
                        string EstimatedTime = "0";
                        if(detail.EstimatedTime == null)
                        {
                            EstimatedTime = "0";
                        }
                        else
                        {
                            EstimatedTime = detail.EstimatedTime;
                        }
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "F", EstimatedTime);
                        rowIndex++;
                    }
                    spreadSheet.Close();
                }
                var inputBytes = System.IO.File.ReadAllBytes(docName);

                var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                {
                    MemoryStream = System.IO.File.ReadAllBytes(docName),
                    FileName = "EmployeeIndex " + productivityDashboardSearchCriteriaInputModel.IndexType + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                    ContentType = "application/xlsx",
                    LoggedInUserId = loggedInContext.LoggedInUserId
                });

                pdfOutputModel = new PdfGenerationOutputModel()
                {
                    ByteStream = inputBytes,
                    BlobUrl = blobUrl,
                    FileName = "EmployeeIndex " + productivityDashboardSearchCriteriaInputModel.IndexType + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                };
                return pdfOutputModel;
            }

            else if(productivityDashboardSearchCriteriaInputModel.IndexType == "GrpIndex")
            {
                path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/EmployeeGroupIndexTemplate.xlsx");
                var pdfOutputModel = new PdfGenerationOutputModel();
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "EmployeeGroupIndexTemplate.xlsx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null)
                    {
                        System.IO.File.Copy(path, docName, true);
                    }

                    LoggingManager.Info("Created a directory to save temp file");
                }
                using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                {
                    uint rowIndex = 1;
                    foreach (var detail in details)
                    {
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "A", detail.GoalName);
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "B", detail.GoalGrpTotal.ToString());
                        rowIndex++;
                    }
                    spreadSheet.Close();
                }
                var inputBytes = System.IO.File.ReadAllBytes(docName);

                var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                {
                    MemoryStream = System.IO.File.ReadAllBytes(docName),
                    FileName = "EmployeeGroupIndexDrilldown" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                    ContentType = "application/xlsx",
                    LoggedInUserId = loggedInContext.LoggedInUserId
                });

                pdfOutputModel = new PdfGenerationOutputModel()
                {
                    ByteStream = inputBytes,
                    BlobUrl = blobUrl,
                    FileName = "EmployeeGroupIndexDrilldown" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                };
                return pdfOutputModel;
            }
            return null;
        }

        private void AddUpdateCellValue(SpreadsheetDocument spreadSheet, string sheetname, uint rowIndex, string columnName, string text)
        {
            // Opening document for editing            
            WorksheetPart worksheetPart =
             RetrieveSheetPartByName(spreadSheet, sheetname);
            if (worksheetPart != null)
            {
                Cell cell = InsertCellInSheet(columnName, (rowIndex + 1), worksheetPart);
                cell.CellValue = new CellValue(text);
                //cell datatype     
                cell.DataType = new EnumValue<CellValues>(CellValues.String);
                // Save the worksheet.            
                worksheetPart.Worksheet.Save();
            }
        }

        //retrieve sheetpart            
        private WorksheetPart RetrieveSheetPartByName(SpreadsheetDocument document, string sheetName)
        {
            IEnumerable<Sheet> sheets =
             document.WorkbookPart.Workbook.GetFirstChild<Sheets>().
            Elements<Sheet>().Where(s => s.Name == sheetName);
            if (sheets.Count() == 0)
            {
                return null;
            }

            string relationshipId = sheets.First().Id.Value;
            WorksheetPart worksheetPart = (WorksheetPart)
            document.WorkbookPart.GetPartById(relationshipId);
            return worksheetPart;
        }

        private Cell InsertCellInSheet(string columnName, uint rowIndex, WorksheetPart worksheetPart)
        {
            Worksheet worksheet = worksheetPart.Worksheet;
            SheetData sheetData = worksheet.GetFirstChild<SheetData>();
            string cellReference = columnName + rowIndex;
            Row row;
            //check whether row exist or not            
            //if row exist            
            if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
            {
                row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
            }
            //if row does not exist then it will create new row            
            else
            {
                row = new Row()
                {
                    RowIndex = rowIndex
                };
                sheetData.Append(row);
            }
            //check whether cell exist or not            
            //if cell exist            
            if (row.Elements<Cell>().Where(c => c.CellReference.Value == columnName + rowIndex).Count() > 0)
            {
                return row.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
            }
            //if cell does not exist            
            else
            {
                Cell refCell = null;
                foreach (Cell cell in row.Elements<Cell>())
                {
                    if (string.Compare(cell.CellReference.Value, cellReference, true) > 0)
                    {
                        refCell = cell;
                        break;
                    }
                }
                Cell newCell = new Cell()
                {
                    CellReference = cellReference
                };
                row.InsertBefore(newCell, refCell);
                worksheet.Save();
                return newCell;
            }
        }
    }
}
