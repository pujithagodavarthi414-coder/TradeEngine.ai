using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Models.GenericForm;
using Btrak.Models.Recruitment;
using Btrak.Models.TestRail;
using Btrak.Services.FileUploadDownload;
using Btrak.Services.MasterData;
using Btrak.Services.Recruitment;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Spire.Doc;
using Hangfire;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Threading.Tasks;
using System.Web.Hosting;
using System.Web.Http;
using System.Web.Http.Results;
using Document = Spire.Doc.Document;
using Btrak.Models.GenericForm;
using Btrak.Services.CompanyStructure;
using Btrak.Models.CompanyStructure;
using Btrak.Services.Chromium;
using Btrak.Models.File;
using Btrak.Services.FileUpload;

namespace BTrak.Api.Controllers.Recruitment
{
    public class RecruitmentApiController : AuthTokenApiController
    {
        private readonly IRecruitmentService _recruitmentService;
        private readonly IFileService _fileService;
        private readonly IFileStoreService _fileStoreService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IChromiumService _chromiumService;
        private readonly IMasterDataManagementService _masterDataManagementService;
        public RecruitmentApiController(IRecruitmentService recruitmentService, IMasterDataManagementService masterDataManagementService, IFileStoreService fileStoreService, IFileService fileService, ICompanyStructureService companyStructureService, IChromiumService chromiumService)
        {
            _companyStructureService = companyStructureService;
            _recruitmentService = recruitmentService;
            _chromiumService = chromiumService;
            _masterDataManagementService = masterDataManagementService;
            _fileStoreService = fileStoreService;
            _fileService = fileService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCandidate)]
        public JsonResult<BtrakJsonResult> UpsertCandidate(CandidateUpsertInputModel candidateUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidate", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? CandidateId;

                if (candidateUpsertInputModel.IsJobLink == true)
                {
                    CandidateId = _recruitmentService.UpsertCandidateJob(candidateUpsertInputModel, LoggedInContext, validationMessages);
                }
                else
                {

                    CandidateId = _recruitmentService.UpsertCandidate(candidateUpsertInputModel, LoggedInContext, validationMessages);
                }
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidate", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidate", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = CandidateId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidate, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCandidateFormSubmitted)]
        public JsonResult<BtrakJsonResult> UpsertCandidateFormSubmitted(GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateFormSubmitted", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string CandidateId="";

                CandidateId = _recruitmentService.UpsertCandidateFormSubmitted(genericFormSubmittedUpsertInputModel, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateFormSubmitted", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateFormSubmitted", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = CandidateId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                //LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidateFormSubmitted, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidates)]
        public JsonResult<BtrakJsonResult> GetCandidates(CandidatesSearchInputModel candidatesSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidates", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidatesSearchOutputModel> candidates = _recruitmentService.GetCandidates(candidatesSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidates", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidates", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidates, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidatesBySkill)]
        public JsonResult<BtrakJsonResult> GetCandidatesBySkill(CandidatesSearchInputModel candidatesSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidatesBySkill", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidatesSearchOutputModel> candidates = _recruitmentService.GetCandidatesBySkill(candidatesSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidatesBySkill", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidatesBySkill", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidates, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendOfferLetter)]
        public JsonResult<BtrakJsonResult> SendOfferLetter(CandidatesSearchInputModel candidatesSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollCalculationTypes", "PayRoll Api"));
                
                var validationMessages = new List<ValidationMessage>();
                FileSearchCriteriaInputModel fileSearchCriteriaInputModel = new FileSearchCriteriaInputModel();
                fileSearchCriteriaInputModel.ReferenceId = candidatesSearchInputModel.CandidateId;
                fileSearchCriteriaInputModel.UserStoryId = candidatesSearchInputModel.CandidateId;
                fileSearchCriteriaInputModel.ReferenceTypeId = Guid.Parse("C2F6B138-E412-4905-9E78-A4AB4D3C804C");
                fileSearchCriteriaInputModel.IsArchived = false;
                fileSearchCriteriaInputModel.SortDirectionAsc = false;
                List<FileApiReturnModel> files = _fileService.SearchFile(fileSearchCriteriaInputModel, LoggedInContext, validationMessages);
                var fileData = files[0].FilePath;
                List<CandidatesSearchOutputModel> list = _recruitmentService.GetCandidates(candidatesSearchInputModel, LoggedInContext, validationMessages);
                var sendMailInputModel = new SendMailInputModel();
                sendMailInputModel.PersonName = list[0].FirstName +" "+ list[0].LastName;
                sendMailInputModel.Email = list[0].Email;
                sendMailInputModel.PdfURL = fileData;
                sendMailInputModel.Date = DateTime.Now.ToString("dd MMM yyyy");

                _companyStructureService.SendEmailOffer(sendMailInputModel , LoggedInContext);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadEmployeeSalaryCertificate", "PayRoll Api"));


                
               
                return Json(new BtrakJsonResult { Data = fileData, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeLoanStatementDocument", "PayRollApiController ", exception.Message), exception);

                return null;
            }
        }

        private PdfGenerationOutputModel GetOfferLetterDocument(Guid? userId, Guid? jobOpeningId, LoggedInContext loggedInContext, string package, DateTime offeredDate)
        {
            var validationMessages = new List<ValidationMessage>();
            var candidatesSearchInputModel = new CandidatesSearchInputModel();
            candidatesSearchInputModel.CandidateId = userId;
            candidatesSearchInputModel.JobOpeningId = jobOpeningId;

            var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
            companySettingsSearchInputModel.Key = "LoanTermsDocument";

            List<CandidatesSearchOutputModel> list = _recruitmentService.GetCandidates(candidatesSearchInputModel, LoggedInContext, validationMessages);
            
            var path = HostingEnvironment.MapPath(@"~\Resources\WordTemplates\SnovasysFreshersOfferLetter.doc");
            var path1 = HostingEnvironment.MapPath(@"~\Resources\WordTemplates");
            var guid = Guid.NewGuid();
            var offerletter = "https://bviewstorage.blob.core.windows.net/173aad87-c8c2-4512-b6bf-e6fccdc7bb78/projects/fc2037e6-aff7-4359-9e05-30d15433a409/Snovasys(Developers)OfferLetter-a1c2781d-b149-4931-a65e-3eaacd37a0d4-3752cc50-7619-4d3d-8b2b-adeb27e0083b.doc";

            Document doc = new Document();
            WebClient webClient = new WebClient();
            using (MemoryStream ms = new MemoryStream(webClient.DownloadData(offerletter)))
            {
                doc.LoadFromStream(ms, FileFormat.Doc);
            }

            doc.SaveToFile(path, FileFormat.Doc);
            
            if (path1 != null)
            {
                var destinationPath1 = System.IO.Path.Combine(path1, guid.ToString());
                string docName1 = System.IO.Path.Combine(destinationPath1, "SnovasysFreshersOfferLetter.doc");
                if (!Directory.Exists(destinationPath1))
                {
                    Directory.CreateDirectory(destinationPath1);

                    if (path1 != null) System.IO.File.Copy(path, docName1, true);

                    LoggingManager.Info("Created a directory to save temp file");
                }
                var Address1 = " ";
                var Address2 = " ";
                if (list[0].AddressJson != null)
                {
                    var jo = Newtonsoft.Json.Linq.JObject.Parse(list[0].AddressJson);
                    Address1 = jo["address1"].ToString() != null ? jo["address1"].ToString() : " ";
                    Address2 = jo["address2"].ToString() != null ? jo["address2"].ToString() :"";
                }

                var CurrentDesignationName = list[0].CurrentDesignationName !=null? "Software Engineer" : list[0].CurrentDesignationName;

                Document document = new Document(path);
                document.Replace("##CandidateName", list[0].FirstName +" "+ list[0].LastName ?? String.Empty, false, true);
                document.Replace("##CandidateFatherName", list[0].FatherName ?? String.Empty, false, true);
                document.Replace("##CandidateFullAddress1", Address1 ?? String.Empty, false, true);
                document.Replace("##Candidate FullAddress2", Address2 ?? String.Empty, false, true);
                document.Replace("##CandidatePhoneNumber", list[0].Phone ?? String.Empty, false, true);
                document.Replace("##position##", CurrentDesignationName ?? String.Empty, false, true);
                document.Replace("##Date", DateTime.Now.ToString("dd MMM yyyy"), false, true);
                document.Replace("##Package", words(Convert.ToDouble(package)), false, true);
                document.Replace("##OfferedDate", offeredDate.ToString("dd MMM yyyy"), false, true);
                document.Replace("##Time", offeredDate.ToString("hh:mm tt"), false, true);
                document.Replace("##ShortPackage", package+"/-", false, true);


                document.SaveToFile(docName1);
              

                var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                {
                    MemoryStream = System.IO.File.ReadAllBytes(docName1),
                    FileName = "SnovasysFreshersOfferLetter.doc"
                });

                var pdfOutputModel = new PdfGenerationOutputModel()
                {
                    ByteStream = System.IO.File.ReadAllBytes(docName1),
                    BlobUrl = blobUrl,
                    FileName = path
                };

                if (Directory.Exists(destinationPath1))
                {
                    System.IO.File.Delete(docName1);
                    Directory.Delete(destinationPath1);

                    LoggingManager.Info("Deleting the temp folder");
                }
                var sendMailInputModel = new SendMailInputModel();
                sendMailInputModel.PersonName = list[0].FirstName + list[0].LastName;
                sendMailInputModel.PdfURL = pdfOutputModel.BlobUrl;
                sendMailInputModel.Date = DateTime.Now.ToString("dd MMM yyyy");

                //_companyStructureService.SendEmailOffer(sendMailInputModel);

                return pdfOutputModel;
            }

            return new PdfGenerationOutputModel();
        }
        public string words(double? numbers, Boolean paisaconversion = false)
        {
            var pointindex = numbers.ToString().IndexOf(".");
            var paisaamt = 0;
            if (pointindex > 0)
                paisaamt = Convert.ToInt32(numbers.ToString().Substring(pointindex + 1, 2));

            int number = Convert.ToInt32(numbers);

            if (number == 0) return "Zero";
            if (number == -2147483648) return "Minus Two Hundred and Fourteen Crore Seventy Four Lakh Eighty Three Thousand Six Hundred and Forty Eight";
            int[] num = new int[4];
            int first = 0;
            int u, h, t;
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            if (number < 0)
            {
                sb.Append("Minus ");
                number = -number;
            }
            string[] words0 = { "", "One ", "Two ", "Three ", "Four ", "Five ", "Six ", "Seven ", "Eight ", "Nine " };
            string[] words1 = { "Ten ", "Eleven ", "Twelve ", "Thirteen ", "Fourteen ", "Fifteen ", "Sixteen ", "Seventeen ", "Eighteen ", "Nineteen " };
            string[] words2 = { "Twenty ", "Thirty ", "Forty ", "Fifty ", "Sixty ", "Seventy ", "Eighty ", "Ninety " };
            string[] words3 = { "Thousand ", "Lakh ", "Crore " };
            num[0] = number % 1000; // units
            num[1] = number / 1000;
            num[2] = number / 100000;
            num[1] = num[1] - 100 * num[2]; // thousands
            num[3] = number / 10000000; // crores
            num[2] = num[2] - 100 * num[3]; // lakhs
            for (int i = 3; i > 0; i--)
            {
                if (num[i] != 0)
                {
                    first = i;
                    break;
                }
            }
            for (int i = first; i >= 0; i--)
            {
                if (num[i] == 0) continue;
                u = num[i] % 10; // ones
                t = num[i] / 10;
                h = num[i] / 100; // hundreds
                t = t - 10 * h; // tens
                if (h > 0) sb.Append(words0[h] + "Hundred ");
                if (u > 0 || t > 0)
                {
                    if (h > 0 || i == 0) sb.Append("and ");
                    if (t == 0)
                        sb.Append(words0[u]);
                    else if (t == 1)
                        sb.Append(words1[u]);
                    else
                        sb.Append(words2[t - 2] + words0[u]);
                }
                if (i != 0) sb.Append(words3[i - 1]);
            }

            if (paisaamt == 0 && paisaconversion == false)
            {
                sb.Append("ruppes only");
            }
            else if (paisaamt > 0)
            {
                var paisatext = words(paisaamt, true);
                sb.AppendFormat("rupees {0} paise only", paisatext);
            }
            return sb.ToString().TrimEnd();
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DownloadOfferLetter)]
        public JsonResult<BtrakJsonResult> DownloadOfferLetter(CandidatesSearchInputModel candidatesSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DownloadOfferLetter", "CandidatesSearchInputModel", candidatesSearchInputModel, "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;
                
                PdfGenerationOutputModel file = GetOfferLetterDocument(candidatesSearchInputModel.CandidateId, candidatesSearchInputModel.JobOpeningId, LoggedInContext,candidatesSearchInputModel.package,candidatesSearchInputModel.offeredDate);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOfferLetter", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOfferLetter", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = file, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PrintAssets", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSkillsByCandidates)]
        public JsonResult<BtrakJsonResult> GetSkillsByCandidates(CandidateSkillsSearchInputModel candidateSkillsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSkillsByCandidates", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidateSkillsSearchOutputModel> CandidateSkillId = _recruitmentService.GetSkillsByCandidates(candidateSkillsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSkillsByCandidates", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSkillsByCandidates", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = CandidateSkillId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidates, exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidateJobOpenings)]
        public JsonResult<BtrakJsonResult> GetCandidateJobOpenings(CandidatesSearchInputModel candidatesSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidates", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<JobOpeningsSearchOutputModel> candidates = _recruitmentService.GetCandidateJobOpenings(candidatesSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidates", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidates", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidates, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidateHistory)]
        public JsonResult<BtrakJsonResult> GetCandidateHistory(CandidateHistorySearchInputModel candidateHistorySearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateHistory", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidateHistorySearchOutputModel> candidateHistory = _recruitmentService.GetCandidateHistory(candidateHistorySearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateHistory", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateHistory", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidateHistory, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertJobOpening)]
        public JsonResult<BtrakJsonResult> UpsertJobOpening(JobOpeningUpsertInputModel jobOpeningUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertJobOpening", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? JobOpeningId = _recruitmentService.UpsertJobOpening(jobOpeningUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertJobOpening", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertJobOpening", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = JobOpeningId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertJobOpening, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetJobOpenings)]
        public JsonResult<BtrakJsonResult> GetJobOpenings(JobOpeningsSearchInputModel jobOpeningsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetJobOpenings", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<JobOpeningsSearchOutputModel> jobOpenings = _recruitmentService.GetJobOpenings(jobOpeningsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetJobOpenings", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetJobOpenings", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = jobOpenings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetJobOpenings, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBrytumViewJobDetails)]
        public JsonResult<BtrakJsonResult> GetBrytumViewJobDetails(JobOpeningsSearchInputModel jobOpeningsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBrytumViewJobDetails", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<BrytumViewJobDetailsOutputModel>  brytumViewJobDetails= _recruitmentService.GetBrytumViewJobDetails(jobOpeningsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBrytumViewJobDetails", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBrytumViewJobDetails", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = brytumViewJobDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetJobOpenings, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertJobOpeningSkill)]
        public JsonResult<BtrakJsonResult> UpsertJobOpeningSkill(JobOpeningSkillUpsertInputModel jobOpeningSkillUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertJobOpeningSkill", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? JobOpeningId = _recruitmentService.UpsertJobOpeningSkill(jobOpeningSkillUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertJobOpeningSkill", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertJobOpeningSkill", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = JobOpeningId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertJobOpeningSkill, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetJobOpeningSkills)]
        public JsonResult<BtrakJsonResult> GetJobOpeningSkills(JobOpeningSkillsSearchInputModel jobOpeningSkillsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetJobOpeningSkills", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<JobOpeningSkillsSearchOutputModel> jobOpeningSkills = _recruitmentService.GetJobOpeningSkills(jobOpeningSkillsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetJobOpeningSkills", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetJobOpeningSkills", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = jobOpeningSkills, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetJobOpeningSkills, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCandidateSkill)]
        public JsonResult<BtrakJsonResult> UpsertCandidateSkill(CandidateSkillUpsertInputModel candidateSkillUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateSkill", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? candidateSkillId = _recruitmentService.UpsertCandidateSkill(candidateSkillUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateSkill", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateSkill", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateSkillId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidateSkill, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidateSkills)]
        public JsonResult<BtrakJsonResult> GetCandidateSkills(CandidateSkillsSearchInputModel candidateSkillsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateSkills", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidateSkillsSearchOutputModel> candidateSkills = _recruitmentService.GetCandidateSkills(candidateSkillsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateSkills", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateSkills", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateSkills, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidateSkills, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCandidateExperience)]
        public JsonResult<BtrakJsonResult> UpsertCandidateExperience(CandidateExperienceUpsertInputModel candidateExperienceUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateExperience", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? candidateExperienceId = _recruitmentService.UpsertCandidateExperience(candidateExperienceUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateExperience", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateExperience", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateExperienceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidateExperience, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidateExperience)]
        public JsonResult<BtrakJsonResult> GetCandidateExperience(CandidateExperienceSearchInputModel candidateExperienceSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateExperience", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidateExperienceSearchOutputModel> candidateExperience = _recruitmentService.GetCandidateExperience(candidateExperienceSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateExperience", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateExperience", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateExperience, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidateExperiences, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCandidateEducation)]
        public JsonResult<BtrakJsonResult> UpsertCandidateEducation(CandidateEducationUpsertInputModel candidateEducationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateEducation", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? candidateEducationId = _recruitmentService.UpsertCandidateEducation(candidateEducationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateEducation", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateEducation", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateEducationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidateEducation, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidateEducation)]
        public JsonResult<BtrakJsonResult> GetCandidateEducation(CandidateEducationSearchInputModel candidateEducationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateEducation", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidateEducationSearchOutputModel> candidateExperience = _recruitmentService.GetCandidateEducation(candidateEducationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateEducation", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateEducation", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateExperience, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidateEducation, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCandidateDocument)]
        public JsonResult<BtrakJsonResult> UpsertCandidateDocument(CandidateDocumentUpsertInputModel candidateDocumentUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateDocument", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? candidateEducationId = _recruitmentService.UpsertCandidateDocument(candidateDocumentUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateDocument", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateDocument", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateEducationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidateDocument, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidateDocuments)]
        public JsonResult<BtrakJsonResult> GetCandidateDocuments(CandidateDocumentsSearchInputModel candidateDocumentsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateDocuments", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidateDocumentsSearchOutputModel> candidateExperience = _recruitmentService.GetCandidateDocuments(candidateDocumentsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateDocuments", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateDocuments", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateExperience, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidateDocuments, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.HiredDocumentsList)]
        public JsonResult<BtrakJsonResult> HiredDocumentsList(CandidateDocumentUpsertInputModel candidateDocumentUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "HiredDocumentsList", "Recruitment Api"));

               var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? candidateEducationId = _recruitmentService.HiredDocumentsList(candidateDocumentUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "HiredDocumentsList", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "HiredDocumentsList", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateEducationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                //LoggingManager.Error(ValidationMessages.ExceptionHiredDocumentsList, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertInterviewProcess)]
        public JsonResult<BtrakJsonResult> UpsertInterviewProcess(InterviewProcessUpsertInputModel interviewProcessUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInterviewProcess", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? interviewProcessId = _recruitmentService.UpsertInterviewProcess(interviewProcessUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewProcess", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewProcess", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = interviewProcessId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertInterviewProcess, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInterviewprocess)]
        public JsonResult<BtrakJsonResult> GetInterviewprocess(InterviewProcessSearchInputModel interviewProcessSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInterviewprocess", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<InterviewProcessSearchOutputModel> interviewProcess = _recruitmentService.GetInterviewprocess(interviewProcessSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInterviewprocess", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInterviewprocess", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = interviewProcess, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetInterviewProcess, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertInterviewProcessConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertInterviewProcessConfiguration(InterviewProcessConfigurationUpsertInputModel interviewProcessConfigurationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInterviewProcessConfiguration", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? interviewProcessConfigurationId = _recruitmentService.UpsertInterviewProcessConfiguration(interviewProcessConfigurationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewProcessConfiguration", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewProcessConfiguration", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = interviewProcessConfigurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertInterviewProcessConfigurations, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInterviewprocessConfiguration)]
        public JsonResult<BtrakJsonResult> GetInterviewprocessConfiguration(InterviewProcessConfigurationSearchInputModel interviewProcessConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInterviewprocessConfiguration", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<InterviewProcessConfigurationSearchOutputModel> interviewProcessConfiguration = _recruitmentService.GetInterviewprocessConfiguration(interviewProcessConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInterviewprocessConfiguration", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInterviewprocessConfiguration", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = interviewProcessConfiguration, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetInterviewProcessConfiguration, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCandidateInterviewSchedule)]
        public JsonResult<BtrakJsonResult> UpsertCandidateInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInterviewProcessConfiguration", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? candidateInterviewScheduleId = _recruitmentService.UpsertCandidateInterviewSchedule(candidateInterviewscheduleUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewProcessConfiguration", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateInterviewSchedule", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateInterviewScheduleId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidateInterviewSchedule, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ApproveCandidateInterviewSchedule)]
        public JsonResult<BtrakJsonResult> ApproveCandidateInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ApproveCandidateInterviewSchedule", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? candidateInterviewScheduleId = _recruitmentService.ApproveCandidateInterviewSchedule(candidateInterviewscheduleUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ApproveCandidateInterviewSchedule", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ApproveCandidateInterviewSchedule", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateInterviewScheduleId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidateInterviewSchedule, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUserCandidateInterviewSchedules)]
        public JsonResult<BtrakJsonResult> GetUserCandidateInterviewSchedules()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserCandidateInterviewSchedules", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidateInterviewScheduleSearchOutputModel> userCandidateInterviewSchedule = _recruitmentService.GetUserCandidateInterviewSchedules(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserCandidateInterviewSchedules", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserCandidateInterviewSchedules", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = userCandidateInterviewSchedule, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidateInterviewSchedule, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidateInterviewSchedule)]
        public JsonResult<BtrakJsonResult> GetCandidateInterviewSchedule(CandidateInterviewScheduleSearchInputModel candidateInterviewScheduleSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInterviewprocessConfiguration", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                var candidateInterviewSchedule = new List<CandidateInterviewScheduleSearchOutputModel>();

                BtrakJsonResult btrakJsonResult;


                if (candidateInterviewScheduleSearchInputModel.IsInterviewer == true)
                {
                    candidateInterviewSchedule = _recruitmentService.GetCandidateInterviewer(candidateInterviewScheduleSearchInputModel, LoggedInContext, validationMessages);
                }
                else
                {
                    candidateInterviewSchedule = _recruitmentService.GetCandidateInterviewSchedule(candidateInterviewScheduleSearchInputModel, LoggedInContext, validationMessages);
                }
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInterviewprocessConfiguration", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInterviewprocessConfiguration", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateInterviewSchedule, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidateInterviewSchedule, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCandidateInterviewFeedBack)]
        public JsonResult<BtrakJsonResult> UpsertCandidateInterviewFeedBack(CandidateInterviewFeedBackUpsertInputModel candidateInterviewFeedBackUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateInterviewFeedBack", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? candidateInterviewFeedBackId = _recruitmentService.UpsertCandidateInterviewFeedBack(candidateInterviewFeedBackUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateInterviewFeedBack", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateInterviewFeedBack", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateInterviewFeedBackId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidateInterviewFeedBack, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidateInterviewFeedBack)]
        public JsonResult<BtrakJsonResult> GetCandidateInterviewFeedBack(CandidateInterviewFeedbackSearchInputModel candidateInterviewFeedbackSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateInterviewFeedBack", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidateInterviewFeedbackSearchOutputModel> candidateInterviewFeedBack = _recruitmentService.GetCandidateInterviewFeedBack(candidateInterviewFeedbackSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateInterviewFeedBack", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateInterviewFeedBack", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateInterviewFeedBack, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidateInterviewFeedBack, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCandidateInterviewFeedBackComments)]
        public JsonResult<BtrakJsonResult> UpsertCandidateInterviewFeedBackComments(CandidateInterviewFeedBackCommentsUpsertInputModel candidateInterviewFeedBackCommentsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateInterviewFeedBackComments", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? candidateInterviewFeedBackCommentId = _recruitmentService.UpsertCandidateInterviewFeedBackComments(candidateInterviewFeedBackCommentsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateInterviewFeedBackComments", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCandidateInterviewFeedBackComments", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateInterviewFeedBackCommentId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidateInterviewFeedBackComments, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCandidateInterviewFeedBackComments)]
        public JsonResult<BtrakJsonResult> GetCandidateInterviewFeedBackComments(CandidateInterviewFeedbackCommentsSearchInputModel candidateInterviewFeedbackCommentsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateInterviewFeedBackComments", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CandidateInterviewFeedbackCommentsSearchOutputModel> candidateInterviewFeedBackComments = _recruitmentService.GetCandidateInterviewFeedBackComments(candidateInterviewFeedbackCommentsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateInterviewFeedBackComments", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateInterviewFeedBackComments", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateInterviewFeedBackComments, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetCandidateInterviewFeedBackComments, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CancelInterviewSchedule)]
        public JsonResult<BtrakJsonResult> CancelInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInterviewProcessConfiguration", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var candidateInterviewSchedule = _recruitmentService.CancelInterviewSchedule(candidateInterviewscheduleUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewProcessConfiguration", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                if (candidateInterviewSchedule != null && candidateInterviewscheduleUpsertInputModel.CandidateEmail != null)
                {
                    candidateInterviewscheduleUpsertInputModel.EmailAddress = candidateInterviewscheduleUpsertInputModel.CandidateEmail;
                    candidateInterviewscheduleUpsertInputModel.Name = candidateInterviewscheduleUpsertInputModel.CandidateName;
                    candidateInterviewscheduleUpsertInputModel.StartTime = candidateInterviewSchedule.StartTime;
                    candidateInterviewscheduleUpsertInputModel.EndTime = candidateInterviewSchedule.EndTime;
                    _recruitmentService.CancelCandidateInterviewScheduleEmail(candidateInterviewscheduleUpsertInputModel, LoggedInContext, validationMessages);
                }
                if (candidateInterviewSchedule != null)
                {
                    var scheduleAssigneeDetails = _recruitmentService.GetScheduleAssigneeDetails(candidateInterviewscheduleUpsertInputModel, LoggedInContext, validationMessages);
                    scheduleAssigneeDetails.ForEach(x =>
                    {
                        if (x.UserName != null)
                        {
                            candidateInterviewscheduleUpsertInputModel.EmailAddress = x.UserName;
                            candidateInterviewscheduleUpsertInputModel.Name = x.AssignToUserName;
                            candidateInterviewscheduleUpsertInputModel.StartTime = candidateInterviewSchedule.StartTime;
                            candidateInterviewscheduleUpsertInputModel.EndTime = candidateInterviewSchedule.EndTime;
                            _recruitmentService.CancelCandidateInterviewScheduleEmail(candidateInterviewscheduleUpsertInputModel, LoggedInContext, validationMessages);
                        }
                    });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewProcessConfiguration", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateInterviewSchedule, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertCandidateInterviewSchedule, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}