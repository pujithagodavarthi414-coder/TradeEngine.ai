using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Text;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Comments;
using Btrak.Models.Crm.Call;
using Btrak.Services.Comments;
using Btrak.Services.CRM;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Twilio.Rest.Video.V1;
using Twilio.TwiML;
using Twilio.TwiML.Voice;
using static Twilio.TwiML.Voice.Dial;


namespace BTrak.Api.Controllers.Call
{
    public class CallApiController : AuthTokenApiController
    {
        private readonly ICallService _callsService;
        private readonly ITwilioWrapperClientService _twilioWrapperClientService;

        public CallApiController(ICallService callService, ITwilioWrapperClientService twilioWrapperClientService)
        {
            _callsService = callService;
            _twilioWrapperClientService = twilioWrapperClientService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCallFeedback)]
        public JsonResult<BtrakJsonResult> UpsertCallFeedback(CallFeedbackUserInputModel callFeedbackUserInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCallFeedback", "Comments Api") + " " + callFeedbackUserInputModel);

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? commentIdIdReturned = _callsService.UpsertCallFeedback(callFeedbackUserInputModel, LoggedInContext, validationMessages);

                LoggingManager.Info("Comment Upsert is completed. Return Guid is " + commentIdIdReturned + ", source command is " + callFeedbackUserInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCallFeedback", "UserStory Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCallFeedback", "UserStory Api"));
                return Json(new BtrakJsonResult { Data = commentIdIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertComment", "CommentsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchCallFeedback)]
        public JsonResult<BtrakJsonResult> SearchCallFeedback(CallFeedbackSearchCriteriaInputModel callFeedbackSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchCallFeedback", "Comments Api"));

                if (callFeedbackSearchCriteriaInputModel == null)
                {
                    callFeedbackSearchCriteriaInputModel = new CallFeedbackSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<CallFeedbackApiReturnModel> comments = _callsService.SearchCallFeedback(callFeedbackSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCallFeedback", "Comments Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCallFeedback", "UserStory Api"));
                return Json(new BtrakJsonResult { Data = comments, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCallFeedback", "CommentsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCallFeedbacksByReceiverId)]
        public JsonResult<BtrakJsonResult> GetCallFeedbacksByReceiverId(Guid id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCallFeedbacksByReceiverId", "Comments Api") + ", Receiver Guid =" + id);

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<CallFeedbackApiReturnModel> CallFeedbackApiReturnModels = _callsService.GetCallFeedbacksByReceiverId(id, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallFeedbacksByReceiverId", "Comments Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallFeedbacksByReceiverId", "Comments Api"));
                return Json(new BtrakJsonResult { Data = CallFeedbackApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCallFeedbacksByReceiverId", "CommentsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCallFeedbackById)]
        public JsonResult<BtrakJsonResult> GetCallFeedbackById(Guid? commentId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCallFeedbackById", "Comments Api") + ", Comment Guid =" + commentId);

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                CallFeedbackApiReturnModel CallFeedbackApiReturnModel = _callsService.GetCallFeedbackById(commentId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallFeedbackById", "Comments Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallFeedbackById", "Comments Api"));
                return Json(new BtrakJsonResult { Data = CallFeedbackApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCallFeedbackById", "CommentsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCallToken)]
        public JsonResult<BtrakJsonResult> GetCallToken()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCallToken", "Call Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                object token = _twilioWrapperClientService.GetToken(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallToken", "Call Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallToken", "Call Api"));
                return Json(new BtrakJsonResult { Data = token, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCallToken", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCallOutcome)]
        public JsonResult<BtrakJsonResult> GetCallOutcome()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCallOutcome", "Call Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                object outcomes = _callsService.GetCallOutcome(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallOutcome", "Call Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallOutcome", "Call Api"));
                return Json(new BtrakJsonResult { Data = outcomes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCallOutcome", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCallingNumbers)]
        public JsonResult<BtrakJsonResult> GetCallingNumbers()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCallingNumbers", "Call Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                object callerIds = _twilioWrapperClientService.GetCallingNumbers(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallingNumbers", "Call Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallingNumbers", "Call Api"));
                return Json(new BtrakJsonResult { Data = callerIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCallingNumbers", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetOutgoingNumbers)]
        public JsonResult<BtrakJsonResult> GetOutgoingNumbers()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetOutgoingNumbers", "Call Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                object callerIds = _twilioWrapperClientService.GetCallingNumbers(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetOutgoingNumbers", "Call Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetOutgoingNumbers", "Call Api"));
                return Json(new BtrakJsonResult { Data = callerIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetOutgoingNumbers", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.MakeCall)]
        public JsonResult<BtrakJsonResult> MakeCall(MakeCallInputModel makeCallInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "MakeCall", "Call Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                object callerIds = _twilioWrapperClientService.MakeCall(makeCallInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MakeCall", "Call Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MakeCall", "Call Api"));
                return Json(new BtrakJsonResult { Data = callerIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MakeCall", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.EndCall)]
        public JsonResult<BtrakJsonResult> EndCall(MakeCallInputModel makeCallInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EndCall", "Call Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                object callerIds = _twilioWrapperClientService.EndCall(makeCallInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EndCall", "Call Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EndCall", "Call Api"));
                return Json(new BtrakJsonResult { Data = callerIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "EndCall", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCallStatusCallback)]
        public JsonResult<BtrakJsonResult> GetCallStatusCallback(string id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCallStatusCallback", "Call Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;
                MakeCallInputModel callInputModel = new MakeCallInputModel() { CallPathSID = id };
                object outcomes = _twilioWrapperClientService.GetCallStatusCallback(callInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallStatusCallback", "Call Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCallStatusCallback", "Call Api"));
                return Json(new BtrakJsonResult { Data = outcomes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCallStatusCallback", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [AllowAnonymous]
        [Route(RouteConstants.Connect)]
        public HttpResponseMessage Connect(string From, string To, bool IsRecord)
        {
            var response = new VoiceResponse();
            var say = new Say("Please wait while we dial you into the call.");
            var dial = new Dial(callerId: From
                    , method: Twilio.Http.HttpMethod.Post
                    , timeout: 60, record: RecordEnum.RecordFromRinging);

            // If recording required
            if (IsRecord)
            {
                dial.Record = RecordEnum.RecordFromRinging;
                var recordingUrl = new Uri("http://localhost/api/record"); // Here I am giving the sample url, but it should be a public url to allow Twilio to post data

                dial.Number(phoneNumber: To
                    //, url: recordingUrl
                    , method: Twilio.Http.HttpMethod.Post);
            }
            else
                dial.Number(phoneNumber: To);

            response.Append(dial);

            XmlMediaTypeFormatter mediaTypeFormatter = new XmlMediaTypeFormatter();
            //return Ok(response.ToString());
            string xml = response.ToString();
            return new HttpResponseMessage()
            {
                Content = new StringContent(response.ToString(), Encoding.UTF8, "application/xml")
            };
            //return Content(System.Net.HttpStatusCode.OK, response, Configuration.Formatters.XmlFormatter);

            //return TwiML(response);
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetRooms)]
        public JsonResult<BtrakJsonResult> GetRooms()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRooms", "Comments Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<RoomDetailsModel> roomDetails = _twilioWrapperClientService.GetAllRooms(LoggedInContext, validationMessages);
                
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRooms", "Call Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRooms", "Call Api"));
                return Json(new BtrakJsonResult { Data = roomDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRooms", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertRoom)]
        public JsonResult<BtrakJsonResult> UpsertRoom(RoomDetailsModel roomDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateRoom", "Comments Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                object data;
                if (roomDetails.Id == null)
                {
                    data = _twilioWrapperClientService.CreateRoom(roomDetails, LoggedInContext, validationMessages);
                }
                else
                {
                    data = _twilioWrapperClientService.UpdateRoomStatus(roomDetails, LoggedInContext, validationMessages);
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateRoom", "Call Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateRoom", "Call Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateRoom", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.RoomParticipants)]
        public JsonResult<BtrakJsonResult> RoomParticipants(RoomDetailsModel roomDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateRoom", "Comments Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var data = _twilioWrapperClientService.RoomParticipants(roomDetails, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateRoom", "Call Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateRoom", "Call Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateRoom", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetVideoCallToken)]
        public JsonResult<BtrakJsonResult> GetVideoCallToken(RoomDetailsModel roomDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetVideoCallToken", "Call Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var data = _twilioWrapperClientService.GetVideoCallToken(roomDetails, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetVideoCallToken", "Call Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetVideoCallToken", "Call Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetVideoCallToken", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetVideoCallTokenForParticipant)]
        public JsonResult<BtrakJsonResult> GetVideoCallTokenForParticipant(RoomDetailsModel roomDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetVideoCallTokenForParticipant", "Call Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var data = _twilioWrapperClientService.GetVideoCallTokenForParticipant(roomDetails, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetVideoCallTokenForParticipant", "Call Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetVideoCallTokenForParticipant", "Call Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetVideoCallTokenForParticipant", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchVideoCallLog)]
        public JsonResult<BtrakJsonResult> SearchVideoCallLog(RoomDetailsModel roomDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchVideoCallLog", "Call Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var data = _callsService.SearchVideoCallLog(roomDetails, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchVideoCallLog", "Call Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchVideoCallLog", "Call Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchVideoCallLog", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetVideoCompositionStatusCallback)]
        public object GetVideoCompositionStatusCallback(CompositionCallbackModel composition)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetVideoCompositionStatusCallback", "Call Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var data = _twilioWrapperClientService.GetVideoCompositionStatusCallback(composition, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetVideoCompositionStatusCallback", "Call Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetVideoCompositionStatusCallback", "Call Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetVideoCompositionStatusCallback", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetVideoCallRoomStatus)]
        public object GetVideoCallRoomStatus(RoomDetailsModel roomDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetVideoCallRoomStatus", "Call Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var data = _twilioWrapperClientService.GetVideoCallRoomStatus(roomDetails, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetVideoCallRoomStatus", "Call Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetVideoCallRoomStatus", "Call Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetVideoCallRoomStatus", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}