using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Chat;
using BTrak.Common;

namespace Btrak.Services.Helpers.Chat
{
    public class ChatValidations
    {
        public static bool ValidateUpsertChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(channelModel.ChannelName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyChannelName
                });
            }

            if (channelModel.ChannelName?.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForChannelName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateNewChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(channelModel.ChannelName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyChannelName
                });
            }

            if (channelModel.ChannelName?.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForChannelName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpdateChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages);

            if (channelModel.ChannelId == null || channelModel.ChannelId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyChannelId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateArchiveChannelByChannelId(Guid channelId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages);

            if (channelId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyChannelId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateArchiveChannelMembers(Guid? channelId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages);

            if (channelId == null || channelId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyChannelId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateGetChannelMembers(Guid? channelId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages);

            if (channelId == null || channelId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyChannelId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateAddEmployeesToChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages);

            if ((channelModel.ChannelId == null || channelModel.ChannelId == Guid.Empty) && (channelModel.ProjectId==null || channelModel.ProjectId == Guid.Empty))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }
            
            return validationMessages.Count <= 0;
        }
    }
}
