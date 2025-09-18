using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Hosting;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.MyWork;
using Btrak.Models.TestRail;
using Btrak.Services.Audit;
using Btrak.Services.FileUploadDownload;
using Btrak.Services.Helpers;
using BTrak.Common;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Newtonsoft.Json;

namespace Btrak.Services.MyWork
{
    public class MyWorkService : IMyWorkService 
    {
        private readonly MyWorkRepository _myWorkRepository;
        private readonly IAuditService _auditService;
        private readonly IFileStoreService _fileStoreService;
            
        public MyWorkService(MyWorkRepository myWorkRepository, IAuditService auditService, IFileStoreService fileStoreService)
        {
            _myWorkRepository = myWorkRepository;
            _auditService = auditService;
            _fileStoreService = fileStoreService;
        }
        public List<GetMyProjectWorkOutputModel> GetMyProjectsWork(MyProjectWorkModel myProjectWorkModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get my work projects", "myProjectWorkModel", myProjectWorkModel, "my project work Service"));
            _auditService.SaveAudit(AppCommandConstants.GetMyProjectsWorkCommandId, myProjectWorkModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting my projects work list ");
            if (!string.IsNullOrEmpty(myProjectWorkModel.TeamMemberId))
            {
                string[] teamMembersStringArray = myProjectWorkModel.TeamMemberId.Split(new[] { ',' });
                List<Guid> teamMembersGuidList = teamMembersStringArray.Select(Guid.Parse).ToList();
                myProjectWorkModel.TeamMemberIdsXml = Utilities.ConvertIntoListXml(teamMembersGuidList.ToList());
            }
            else
            {
                myProjectWorkModel.TeamMemberIdsXml = null;
            }
            if (!string.IsNullOrEmpty(myProjectWorkModel.UserStoryStatusIds))
            {
                string[] userStoryStatusIdsStringArray = myProjectWorkModel.UserStoryStatusIds.Split(new[] { ',' });
                List<Guid> userStoryStatusIdsGuidList = userStoryStatusIdsStringArray.Select(Guid.Parse).ToList();
                myProjectWorkModel.UserStoryStatusIdsXml = Utilities.ConvertIntoListXml(userStoryStatusIdsGuidList.ToList());
            }
            else
            {
                myProjectWorkModel.UserStoryStatusIdsXml = null;
            }
            List<GetMyProjectWorkOutputModel> getProjectsWorkList = _myWorkRepository.GetMyProjectsWork(myProjectWorkModel, loggedInContext, validationMessages).ToList();
            return getProjectsWorkList;
        }

        public MyWorkOverViewOutputModel GetMyWorkOverViewDetails(MyWorkOverViewInputModel myWorkOverViewInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMyWorkOverViewDetails", "myWorkOverViewInputModel", myWorkOverViewInputModel, "my work Service"));
            _auditService.SaveAudit(AppCommandConstants.GetMyWorkOverViewDetailsCommandId, myWorkOverViewInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                myWorkOverViewInputModel, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(myWorkOverViewInputModel.TeamMemberId))
            {
                string[] teamMembersStringArray = myWorkOverViewInputModel.TeamMemberId.Split(new[] { ',' });
                List<Guid> teamMembersGuidList = teamMembersStringArray.Select(Guid.Parse).ToList();
                myWorkOverViewInputModel.TeamMembersXml = Utilities.ConvertIntoListXml(teamMembersGuidList.ToList());
            }
            else
            {
                myWorkOverViewInputModel.TeamMembersXml = null;
            }

            LoggingManager.Info("Getting My Work OverView Details");
            MyWorkOverViewOutputModel getMyWorkOverViewDetails = _myWorkRepository.GetMyWorkOverViewDetails(myWorkOverViewInputModel, loggedInContext, validationMessages).FirstOrDefault();
            return getMyWorkOverViewDetails;
        }

        public List<UserHistoricalWorkReportSearchSpOutputModel> GetUserHistoricalWorkReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserHistoricalWorkReport", "userHistoricalSearchInputModel", userHistoricalSearchInputModel, "my work Service"));
            _auditService.SaveAudit(AppCommandConstants.GetMyWorkOverViewDetailsCommandId, userHistoricalSearchInputModel, loggedInContext);

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Getting User Historical Work Report");

            List<UserHistoricalWorkReportSearchSpOutputModel> userHistoricalWorkReportSearchSpOutputModels = _myWorkRepository.GetUserHistoricalWorkReport(userHistoricalSearchInputModel, loggedInContext, validationMessages);

            return userHistoricalWorkReportSearchSpOutputModels;
        }
        public List<UserHistoricalWorkReportSearchSpOutputModel> GetUserHistoricalCompletedWorkReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserHistoricalCompletedWorkReport", "userHistoricalSearchInputModel", userHistoricalSearchInputModel, "my work Service"));
            _auditService.SaveAudit(AppCommandConstants.GetMyCompletedWorkOverViewDetailsCommandId, userHistoricalSearchInputModel, loggedInContext);

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Getting User Historical Completed Work Report");

            List<UserHistoricalWorkReportSearchSpOutputModel> userHistoricalCompletedWorkReportSearchSpOutputModels = _myWorkRepository.GetUserHistoricalCompletedWorkReport(userHistoricalSearchInputModel, loggedInContext, validationMessages);

            return userHistoricalCompletedWorkReportSearchSpOutputModels;
        }

        public PdfGenerationOutputModel GetWorkReportDetailsUploadTemplate(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var details = _myWorkRepository.GetUserHistoricalWorkReport(userHistoricalSearchInputModel, loggedInContext, validationMessages);
            var path = "";
            path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/WorkReport.xlsx");
            var path1 = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates");
            List<string> excelColumns = new List<string>();
            List<string> excelFields = new List<string>();
            foreach(var value in userHistoricalSearchInputModel.ExcelColumnList)
            {
                excelColumns.Add(value.ExcelColumn);
                excelFields.Add(value.ExcelField);
            }

            var hiddenColumns = userHistoricalSearchInputModel.HiddenColumnList;
            for(int i=0; i< hiddenColumns.Count(); i++)
            {
                var index = excelColumns.IndexOf(hiddenColumns[i]);
                excelColumns.RemoveAt(index);
                excelFields.RemoveAt(index);
            }
            var colums = userHistoricalSearchInputModel.HiddenColumnList;
            var columLength = excelColumns.Count();
            string[] columnIndex = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
            var guid = Guid.NewGuid();
            if (path1 != null)
            {
                var pdfOutputModel = new PdfGenerationOutputModel();
                DataTable dt = new DataTable();
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "WorkReport.xlsx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null)
                    {
                        System.IO.File.Copy(path, docName, true);
                    }

                    LoggingManager.Info("Created a directory to save temp file");
                }
                for (int i = 0; i < columLength; i++)
                {
                    dt.Columns.Add(excelColumns[i], typeof(string));
                }
                uint rowIndex = 1;
                foreach (var detail in details)
                {
                    DataRow dr = dt.NewRow();
                    for (int i = 0; i < columLength; i++)
                    {
                        dr[i] = StringToCSVCell(ReturnCellValue(detail, excelFields[i], userHistoricalSearchInputModel.TimeZone));
                    }
                    rowIndex++;
                    dt.Rows.Add(dr);
                }
                var CSVFileData = DataTableToCSV(dt);
                var convertedCSV = Encoding.GetEncoding("iso-8859-1").GetBytes(CSVFileData);

                var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                {
                    MemoryStream = Encoding.GetEncoding("iso-8859-1").GetBytes(CSVFileData),
                    FileName = "Work report" + DateTime.Now.ToString("yyyy-MM-dd") + ".csv",
                    ContentType = "text/csv"
                });

                pdfOutputModel = new PdfGenerationOutputModel()
                {
                    ByteStream = convertedCSV,
                    BlobUrl = blobUrl,
                    FileName = "Work report" + DateTime.Now.ToString("yyyy-MM-dd") + ".csv",
                };
                //using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                //{
                //    for (int i=0; i < columLength; i++)
                //    {
                //        AddUpdateCellValue(spreadSheet, "Sheet1", 0, columnIndex[i], excelColumns[i]);
                //    }

                //    uint rowIndex = 1;
                //    foreach (var detail in details)
                //    {
                //        for(int i=0; i< columLength; i++)
                //        {
                //            AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, columnIndex[i], ReturnCellValue(detail, excelFields[i], userHistoricalSearchInputModel.TimeZone));
                //        }
                //        rowIndex++;
                //    }
                //    spreadSheet.Close();
                //}
                //var inputBytes = System.IO.File.ReadAllBytes(docName);

                //var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                //{
                //    MemoryStream = System.IO.File.ReadAllBytes(docName),
                //    FileName = "Work report" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                //    ContentType = "application/xlsx",
                //    LoggedInUserId = loggedInContext.LoggedInUserId
                //});

                //pdfOutputModel = new PdfGenerationOutputModel()
                //{
                //    ByteStream = inputBytes,
                //    BlobUrl = blobUrl,
                //    FileName = "Work report" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                //};
                return pdfOutputModel;
            }
            return null;
        }

        public static string StringToCSVCell(string value)
        {
            if (value != null)
            {
                var mustQuote = value.Any(x => x == ',' || x == '\"' || x == '\r' || x == '\n');

                if (!mustQuote)
                {
                    return value;
                }

                value = value.Replace('“', '"').Replace('”', '"').Replace("\"", "\"\"");
                return value;
            }
            return null;

        }

        private string DataTableToCSV(DataTable dt)
        {
            StringBuilder sb = new StringBuilder();

            // Create the header row
            for (int i = 0; i <= dt.Columns.Count - 1; i++)
            {
                // Append column name in quotes
                sb.Append("\"" + dt.Columns[i].ColumnName + "\"");
                // Add carriage return and linefeed if last column, else add comma
                sb.Append(i == dt.Columns.Count - 1 ? "\n" : ",");
            }
            foreach (DataRow row in dt.Rows)
            {
                for (int i = 0; i <= dt.Columns.Count - 1; i++)
                {
                    // Append value in quotes
                    //sb.Append("""" & row.Item(i) & """")

                    // OR only quote items that that are equivilant to strings
                    sb.Append(object.ReferenceEquals(dt.Columns[i].DataType, typeof(string)) || object.ReferenceEquals(dt.Columns[i].DataType, typeof(char)) ? "\"" + row[i] + "\"" : row[i]);

                    // Append CR+LF if last field, else add Comma
                    sb.Append(i == dt.Columns.Count - 1 ? "\n" : ",");
                }
            }
            return sb.ToString();
        }
        public PdfGenerationOutputModel GetCompletedWorkReportDetailsUploadTemplate(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var details = _myWorkRepository.GetUserHistoricalCompletedWorkReport(userHistoricalSearchInputModel, loggedInContext, validationMessages);
            var path = "";
            path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/WorkReport.xlsx");
            var path1 = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates");
            List<string> excelColumns = new List<string>();
            List<string> excelFields = new List<string>();
            foreach (var value in userHistoricalSearchInputModel.ExcelColumnList)
            {
                excelColumns.Add(value.ExcelColumn);
                excelFields.Add(value.ExcelField);
            }

            var hiddenColumns = userHistoricalSearchInputModel.HiddenColumnList;
            for (int i = 0; i < hiddenColumns.Count(); i++)
            {
                var index = excelColumns.IndexOf(hiddenColumns[i]);
                excelColumns.RemoveAt(index);
                excelFields.RemoveAt(index);
            }
            var colums = userHistoricalSearchInputModel.HiddenColumnList;
            var columLength = excelColumns.Count();
            string[] columnIndex = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
            var guid = Guid.NewGuid();
            if (path1 != null)
            {
                var pdfOutputModel = new PdfGenerationOutputModel();
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "WorkReport.xlsx");
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
                    for (int i = 0; i < columLength; i++)
                    {
                        AddUpdateCellValue(spreadSheet, "Sheet1", 0, columnIndex[i], excelColumns[i]);
                    }

                    uint rowIndex = 1;
                    foreach (var detail in details)
                    {
                        for (int i = 0; i < columLength; i++)
                        {
                            AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, columnIndex[i], ReturnCellValue(detail, excelFields[i], userHistoricalSearchInputModel.TimeZone));
                        }
                        rowIndex++;
                    }
                    spreadSheet.Close();
                }
                var inputBytes = System.IO.File.ReadAllBytes(docName);

                var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                {
                    MemoryStream = System.IO.File.ReadAllBytes(docName),
                    FileName = "Work report" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                    ContentType = "application/xlsx",
                    LoggedInUserId = loggedInContext.LoggedInUserId
                });

                pdfOutputModel = new PdfGenerationOutputModel()
                {
                    ByteStream = inputBytes,
                    BlobUrl = blobUrl,
                    FileName = "Work report" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                };
                return pdfOutputModel;
            }
            return null;
        }

        private static WorksheetPart GetWorksheetPartByName(SpreadsheetDocument document, string sheetName, string newName)
        {
            var sheets = document.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>().Where(s => s.Name == sheetName).ToList();

            if (!sheets.Any())
            {
                return null;
            }

            string relationshipId = sheets.First().Id.Value;
            sheets.First().Name = newName;
            WorksheetPart worksheetPart = (WorksheetPart)document.WorkbookPart.GetPartById(relationshipId);
            return worksheetPart;
        }

        private string ConvertDate(int day)
        {
            var day1 = day > 9 ? day + "" : 0 + "" + day;
            return day1;
        }

        private string ConvertValue(UserHistoricalWorkReportSearchSpOutputModel detail)
        {
            return null;
        }

        private string ReturnCellValue(UserHistoricalWorkReportSearchSpOutputModel detail, string field, int timeZone)
        {
            if (field == "SheetUpdatedDateTime")
                return !String.IsNullOrEmpty(detail.UpdatedDateTime?.ToString()) ? detail.SheetUpdatedDateTime  : string.Empty;//ConvertDate(detail.UpdatedDateTime.Value.Day) + "-" + ConvertNumbertoMonth(detail.UpdatedDateTime.Value.Month) + "-" + detail.UpdatedDateTime.Value.Year : string.Empty; //return detail.UpdatedDateTime.ToString() ?? string.Empty;
            if (field == "ProjectName")
                return detail.ProjectName ?? string.Empty;
            if(field == "GoalName")
                return detail.GoalName != null ? "("+ detail.GoalUniqueName + ")" +detail.GoalName : " ";
            if(field == "SprintName")
                return detail.SprintName != null ? detail.SprintName : " ";
            if(field == "UserStoryName")
                return "("+detail.UserStoryUniqueName +")"+detail.UserStoryName ?? string.Empty;
            if(field == "Developer")
                return detail.Developer ?? string.Empty;
            if(field == "EstimatedTime")
                return detail.EstimatedTime ?? string.Empty;
            if(field == "SpentTime")
                return detail.SpentTime ?? string.Empty;
            if (field == "SheetDeadLineDate")
                return !String.IsNullOrEmpty(detail.DeadLineDate?.ToString()) ? detail.SheetDeadLineDate : string.Empty;//ConvertDate(detail.DeadLineDate.Value.Day) + "-" + ConvertNumbertoMonth(detail.DeadLineDate.Value.Month) + "-" + detail.DeadLineDate.Value.Year : string.Empty; //detail.DeadLineDate.ToString() ?? string.Empty;
            if (field == "SheetLatestDevInprogressDate")
                return !String.IsNullOrEmpty(detail.LatestDevInprogressDate?.ToString()) ? detail.SheetLatestDevInprogressDate : string.Empty;//ConvertDate(detail.LatestDevInprogressDate.Value.Day) + "-" + ConvertNumbertoMonth(detail.LatestDevInprogressDate.Value.Month) + "-" + detail.LatestDevInprogressDate.Value.Year : string.Empty;//detail.LatestDevInprogressDate.ToString() ?? string.Empty;
            if (field == "SheetLatestDevCompletedDate")
                return !String.IsNullOrEmpty(detail.LatestDevCompletedDate?.ToString()) ? detail.SheetLatestDevCompletedDate : string.Empty;//ConvertDate(detail.LatestDevCompletedDate.Value.Day) + "-" + ConvertNumbertoMonth(detail.LatestDevCompletedDate.Value.Month) + "-" + detail.LatestDevCompletedDate.Value.Year : string.Empty;//detail.LatestDevCompletedDate.ToString() ?? string.Empty;
            if (field == "SheetDeployedDate")
                return !String.IsNullOrEmpty(detail.LatestDeployedDate?.ToString()) ? detail.SheetDeployedDate : string.Empty;//ConvertDate(detail.LatestDeployedDate.Value.Day) + "-" + ConvertNumbertoMonth(detail.LatestDeployedDate.Value.Month) + "-" + detail.LatestDeployedDate.Value.Year : string.Empty;//detail.LatestDeployedDate.ToString() ?? string.Empty;
            if (field == "SheetQaApprovedDate")
                return !String.IsNullOrEmpty(detail.QaApprovedDate?.ToString()) ? detail.SheetQaApprovedDate : string.Empty;//ConvertDate(detail.QaApprovedDate.Value.Day) + "-" + ConvertNumbertoMonth(detail.QaApprovedDate.Value.Month) + "-" + detail.QaApprovedDate.Value.Year : string.Empty;//detail.QaApprovedDate.ToString() ?? string.Empty;
            if (field == "CurrentStatus")
                return detail.CurrentStatus.ToString() ?? string.Empty;
            if(field == "BugsCount")
                return detail.BugsCount.ToString();
            if(field == "RepalnUserStoriesCount")
                return detail.RepalnUserStoriesCount.ToString() ?? string.Empty;
            if(field == "BoardTypeName")
                return detail.BoardTypeName.ToString() ?? string.Empty;
            if(field == "ApprovedUserName")
                return detail.ApprovedUserName != null ? detail.ApprovedUserName : "";
            if(field == "IsProductive")
                return detail.IsProductive == true ? "Yes" : "No";
            if (field == "BouncedBackCount")
                return detail.BouncedBackCount.ToString();
            return null;
        }

        private void AddUpdateCellValue(SpreadsheetDocument spreadSheet, string sheetname, uint rowIndex, string columnName, string text)
        {
            // Opening document for editing            
            WorksheetPart worksheetPart = RetrieveSheetPartByName(spreadSheet, sheetname);
            if (worksheetPart != null)
            {
                Cell cell = InsertCellInSheet(columnName, (rowIndex + 1), worksheetPart);
                cell.CellValue = new CellValue(text);
                if(rowIndex == 0)
                {
                    CellFormat cellFormat = cell.StyleIndex != null ? GetCellFormat(spreadSheet.WorkbookPart, cell.StyleIndex).CloneNode(true) as CellFormat : new CellFormat();
                    cellFormat.FontId = InsertFont(spreadSheet.WorkbookPart, GenerateFont(11));
                    cell.StyleIndex = InsertCellFormat(spreadSheet.WorkbookPart, cellFormat);
                }
                //cell datatype     
                cell.DataType = new EnumValue<CellValues>(CellValues.String);
                // Save the worksheet.            
                worksheetPart.Worksheet.Save();
            }
        }

        private static uint InsertCellFormat(WorkbookPart workbookPart, CellFormat cellFormat)
        {
            CellFormats cellFormats = workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (cellFormat != null) cellFormats.Append(cellFormat);
            return cellFormats.Count++;
        }

        private static uint InsertFont(WorkbookPart workbookPart, Font font)
        {
            Fonts fonts = workbookPart.WorkbookStylesPart.Stylesheet.Elements<Fonts>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (font != null) fonts.Append(font);
            return fonts.Count++;
        }

        private static CellFormat GetCellFormat(WorkbookPart workbookPart, uint styleIndex)
        {
            return workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First().Elements<CellFormat>().ElementAt((int)styleIndex);
        }

        private static Font GenerateFont(int fontSize = 11, Color color = null)
        {
            var font = new Font(new FontSize { Val = fontSize }, new Bold(), color);
            if (color != null)
                font.Color = color;
            return font;
        }


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

        private string ConvertDateTimeToDate(DateTimeOffset? dateTime, int timeZone)
        {
            var date = dateTime - TimeSpan.FromMinutes(timeZone);
            var returnDate = ConvertDate(date.Value.Day) + "-" + ConvertNumbertoMonth(date.Value.Month) + "-" + date.Value.Year;
            return returnDate;
        }

        private string ConvertNumbertoMonth(int n)
        {
            if (n == 1)
                return "Jan";
            if (n == 2)
                return "Feb";
            if (n == 3)
                return "Mar";
            if (n == 4)
                return "Apr";
            if (n == 5)
                return "May";
            if (n == 6)
                return "Jun";
            if (n == 7)
                return "Jul";
            if (n == 8)
                return "Aug";
            if (n == 9)
                return "Sep";
            if (n == 10)
                return "Oct";
            if (n == 11)
                return "Nov";
            if (n == 12)
                return "Dec";
            return String.Empty;
        }

        public List<EmployeeWorkLogReportOutputmodel> GetEmployeeWorkLogReports(EmployeeWorkLogReportInputModel employeeWorkLogReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserHistoricalWorkReport", "employeeWorkLogReportInputModel", employeeWorkLogReportInputModel, "my work Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeWorkLogReportsCommandId, employeeWorkLogReportInputModel, loggedInContext);

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Getting Employee Work Log Report");

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                employeeWorkLogReportInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (employeeWorkLogReportInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                employeeWorkLogReportInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            List<EmployeeWorkLogReportOutputmodel> emlpEmployeeWorkLogReportOutputmodels = _myWorkRepository.GetEmployeeWorkLogReport(employeeWorkLogReportInputModel, loggedInContext, validationMessages);

            List<EmployeeWorkLogReportOutputmodel> employeeWorkLogReportOutputmodels = new List<EmployeeWorkLogReportOutputmodel>();

            foreach (EmployeeWorkLogReportOutputmodel commentModel in emlpEmployeeWorkLogReportOutputmodels)
            {
                //commentModel.Comments = CommentValidations.GetSubStringFromHtml(commentModel.Comments,commentModel.Comments.Length);
                commentModel.CommentsList = (commentModel.Comments!=null)?  commentModel.Comments.Split('`').ToList<string>():null;
                employeeWorkLogReportOutputmodels.Add(commentModel);
            }

            return emlpEmployeeWorkLogReportOutputmodels;
        }

        public List<EmployeeYearlyProductivityReportOutputModel> GetEmployeeYearlyProductivityReport(GetEmployeeYearlyProductivityReportInputModel getEmployeeYearlyProductivityReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeYearlyProductivityReport", "GetEmployeeYearlyProductivityReportInputModel", getEmployeeYearlyProductivityReportInputModel, "my work Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeWorkLogReportsCommandId, getEmployeeYearlyProductivityReportInputModel, loggedInContext);

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Getting Employee Work Log Report");

            List<EmployeeYearlyProductivityReportOutputModel> employeeYearlyProductivityReportOutputModel = _myWorkRepository.GetEmployeeYearlyProductivityReport(getEmployeeYearlyProductivityReportInputModel, loggedInContext, validationMessages);

            return employeeYearlyProductivityReportOutputModel;
        }

        public GeneralOutput GetGoalBurnDownChart(GetGoalBurnDownChartInputModel getGoalBurnDownChartInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGoalBurnDownChart", "GetGoalBurnDownChartInputModel", getGoalBurnDownChartInputModel, "my work Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeWorkLogReportsCommandId, getGoalBurnDownChartInputModel, loggedInContext);

            if ((getGoalBurnDownChartInputModel.IsFromSprint == null || getGoalBurnDownChartInputModel.IsFromSprint == false) && (getGoalBurnDownChartInputModel.GoalId == null || getGoalBurnDownChartInputModel.GoalId == Guid.Empty))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
                return null;
            } 
            if(getGoalBurnDownChartInputModel.IsFromSprint == true && (getGoalBurnDownChartInputModel.SprintId == null || getGoalBurnDownChartInputModel.SprintId == Guid.Empty))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySprintId
                });
                return null;
            }

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Get Goal Burn Down Chart");

            List<GetGoalBurnDownChartOutputModel> getGoalBurnDownChartOutputModel = _myWorkRepository.GetGoalBurnDownChart(getGoalBurnDownChartInputModel, loggedInContext, validationMessages);

            if(getGoalBurnDownChartOutputModel.Count > 0)
            {
                List<Models.MyWork.Values> expected = getGoalBurnDownChartOutputModel.Select(p => new Models.MyWork.Values()
                {
                    Time = p.Date.ToString("dd-MMM-yyyy"),
                    DateTime = p.Date,
                    Value = p.ExpectedBurnDown
                }).ToList();

                List<Models.MyWork.Values> actual = getGoalBurnDownChartOutputModel.Select(p => new Models.MyWork.Values()
                {
                    Time = p.Date.ToString("dd-MMM-yyyy"),
                    DateTime = p.Date,
                    Value = p.ActualBurnDown
                }).ToList();

                DateTime currentDate = DateTime.Now;
                actual = actual.Where(x => x.DateTime < currentDate).ToList();

                var output = new GeneralOutput()
                {
                    ActualBurnDown = actual,
                    ExpectedBurnDown = expected                    
                };

                return output;
            }

            return null;
        }

        public List<GetMyWorkOutputModel> GetMyWork(MyWorkInputModel myWorkInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get my work", "myWorkInputModel", myWorkInputModel, "get my work service"));
            _auditService.SaveAudit(AppCommandConstants.GetMyWorkCommandId, myWorkInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting my work list ");
            if (!string.IsNullOrEmpty(myWorkInputModel.TeamMemberId))
            {
                string[] teamMembersStringArray = myWorkInputModel.TeamMemberId.Split(new[] { ',' });
                List<Guid> teamMembersGuidList = teamMembersStringArray.Select(Guid.Parse).ToList();
                myWorkInputModel.TeamMemberIdsXml = Utilities.ConvertIntoListXml(teamMembersGuidList.ToList());
            }
            else
            {
                myWorkInputModel.TeamMemberIdsXml = null;
            }
            if (!string.IsNullOrEmpty(myWorkInputModel.UserStoryStatusIds))
            {
                string[] userStoryStatusIdsStringArray = myWorkInputModel.UserStoryStatusIds.Split(new[] { ',' });
                List<Guid> userStoryStatusIdsGuidList = userStoryStatusIdsStringArray.Select(Guid.Parse).ToList();
                myWorkInputModel.UserStoryStatusIdsXml = Utilities.ConvertIntoListXml(userStoryStatusIdsGuidList.ToList());
            }
            else
            {
                myWorkInputModel.UserStoryStatusIdsXml = null;
            }
            if (!string.IsNullOrEmpty(myWorkInputModel.TeamMembersList))
            {
                string[] teamMembersStringArray = myWorkInputModel.TeamMembersList.Split(new[] { ',' });
                List<Guid> teamMembersGuidList = teamMembersStringArray.Select(Guid.Parse).ToList();
                myWorkInputModel.TeamMembersXml = Utilities.ConvertIntoListXml(teamMembersGuidList.ToList());
            }
            else
            {
                myWorkInputModel.TeamMembersXml = null;
            }
            List<GetMyWorkOutputModel> getMyWorkList = _myWorkRepository.GetMyWork(myWorkInputModel, loggedInContext, validationMessages).ToList();
            return getMyWorkList;
        }


        public IEnumerable<dynamic> GetEmployeeLogTimeDetailsReport(EmployeeLogTimeDetailSearchInputModel employeeLogTimeDetailSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeLogTimeDetailsReport", "employeeLogTimeDetailSearchInputModel", employeeLogTimeDetailSearchInputModel, "my work Service"));
            //_auditService.SaveAudit(AppCommandConstants.GetMyWorkOverViewDetailsCommandId, employeeLogTimeDetailSearchInputModel, loggedInContext);

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Getting User Historical Work Report");

            IEnumerable<dynamic> employeeLogTimeDetailsSearchSpOutputModels = _myWorkRepository.GetEmployeeLogTimeDetailsReport(employeeLogTimeDetailSearchInputModel, loggedInContext, validationMessages);

            return employeeLogTimeDetailsSearchSpOutputModels;
        }

        public IEnumerable<dynamic> GetUsersSpentTimeDetailsReport(EmployeeLogTimeDetailSearchInputModel employeeLogTimeDetailSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUsersSpentTimeDetailsReport", "employeeLogTimeDetailSearchInputModel", employeeLogTimeDetailSearchInputModel, "my work Service"));
            //_auditService.SaveAudit(AppCommandConstants.GetMyWorkOverViewDetailsCommandId, employeeLogTimeDetailSearchInputModel, loggedInContext);

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                employeeLogTimeDetailSearchInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (employeeLogTimeDetailSearchInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                employeeLogTimeDetailSearchInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            LoggingManager.Info("Getting User Historical Work Report");

            IEnumerable<dynamic> employeeLogTimeDetailsSearchSpOutputModels = _myWorkRepository.GetUsersSpentTimeDetailsReport(employeeLogTimeDetailSearchInputModel, loggedInContext, validationMessages);

            return employeeLogTimeDetailsSearchSpOutputModels;
        }

        public List<WorkItemsDetailsSearchOutPutModel> GetWorkItemsDetailsReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWorkItemsDetailsReport", "userHistoricalSearchInputModel", userHistoricalSearchInputModel, "my work Service"));
            _auditService.SaveAudit(AppCommandConstants.GetMyWorkOverViewDetailsCommandId, userHistoricalSearchInputModel, loggedInContext);

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Getting Work Items Details Report");

            List<WorkItemsDetailsSearchOutPutModel> userHistoricalWorkReportSearchSpOutputModels = _myWorkRepository.GetWorkItemsDetailsReport(userHistoricalSearchInputModel, loggedInContext, validationMessages);

            return userHistoricalWorkReportSearchSpOutputModels;
        }
    }
}
