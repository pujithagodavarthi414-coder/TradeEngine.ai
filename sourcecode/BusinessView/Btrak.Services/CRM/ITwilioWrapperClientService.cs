using System;
using System.Collections.Generic;
using System.Web;
using Btrak.Models;
using Btrak.Models.Comments;
using BTrak.Common;
using Btrak.Models.Crm.Call;
using System.IO;
using System.Threading.Tasks;
using Twilio.Rest.Video.V1;

namespace Btrak.Services.CRM
{
    public interface ITwilioWrapperClientService
    {
        string GetToken(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CallResourceModel CreateCall(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<OutgoingCallerIdModel> GetCallingNumbers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CallResourceModel GetCallStatusCallback(MakeCallInputModel callInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CallResourceModel MakeCall(MakeCallInputModel makeCallInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CallResourceModel EndCall(MakeCallInputModel makeCallInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Stream GetStreamFromRecordUrl(string recordSid, string recordUrl);
        bool DeleteRecordingTwilio(string recordSid, string recordUrl);
        List<RoomDetailsModel> GetAllRooms(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        object CreateRoom(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        object UpdateRoomStatus(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ParticipantModel> RoomParticipants(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //string GetVideoToken(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetVideoCallTokenForParticipant(RoomDetailsModel roomDetails, List<ValidationMessage> validationMessages);
        object GetVideoCallToken(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetVideoCompositionStatusCallback(CompositionCallbackModel composition, List<ValidationMessage> validationMessages);
        string GetVideoCallRoomStatus(RoomDetailsModel roomDetails, List<ValidationMessage> validationMessages);
    }
}
