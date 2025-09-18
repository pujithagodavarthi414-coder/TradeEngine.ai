using System;
using System.Collections.Generic;
using Btrak.Models;
using BTrak.Common;
using Btrak.Models.Recruitment;
using System.Text.RegularExpressions;

namespace Btrak.Services.Helpers.RecruitmentHelper
{
    public class RecruitmentValidationHelper
    {
        public static bool UpsertJobOpeningStatusValidation(JobOpeningStatusUpsertInputModel jobOpeningStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(jobOpeningStatusUpsertInputModel.Status))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyJobOpeningStatus
                });
            }

            if (jobOpeningStatusUpsertInputModel.Status != null && jobOpeningStatusUpsertInputModel.Status.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionUpsertJobOpeningStatus
                });
            }

            //if (jobOpeningStatusUpsertInputModel.JobOpeningStatusId == null || jobOpeningStatusUpsertInputModel.JobOpeningStatusId == Guid.Empty)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.ExceptionUpsertJobOpeningStatus
            //    });
            //}

            return validationMessages.Count <= 0;
        }

        public static bool UpsertSourceValidation(SourceUpsertInputModel sourceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(sourceUpsertInputModel.Name))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyJobOpeningStatus
                });
            }

            if (sourceUpsertInputModel.Name != null && sourceUpsertInputModel.Name.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySourceName
                });
            }

            //if (sourceUpsertInputModel.SourceId == null || sourceUpsertInputModel.SourceId == Guid.Empty)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.ExceptionUpsertSource
            //    });
            //}

            return validationMessages.Count <= 0;
        }

        public static bool CandidateUpsertInputModel(CandidateUpsertInputModel candidateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(candidateUpsertInputModel.FirstName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFirstName
                });
            }

            if (!string.IsNullOrEmpty(candidateUpsertInputModel.FirstName))
            {
                if (candidateUpsertInputModel.FirstName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.FirstNameLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(candidateUpsertInputModel.LastName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFirstName
                });
            }

            if (!string.IsNullOrEmpty(candidateUpsertInputModel.LastName))
            {
                if (candidateUpsertInputModel.FirstName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.FirstNameLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(candidateUpsertInputModel.AddressJson))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyAddressJson
                });
            }

            if (!string.IsNullOrEmpty(candidateUpsertInputModel.AddressJson))
            {
                if (candidateUpsertInputModel.AddressJson.Length > 150)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.AddressJsonLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(candidateUpsertInputModel.Email))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmail
                });
            }

            if (!string.IsNullOrEmpty(candidateUpsertInputModel.Email))
            {
                if (candidateUpsertInputModel.Email.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.EmailLengthExceeded
                    });
                }
                string email = candidateUpsertInputModel.Email;
                Regex regex = new Regex(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$");
                Match match = regex.Match(email);
                if (!match.Success)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.EmailFormat
                    });
                }
            }
            

            return validationMessages.Count <= 0;
        }

        public static bool JobOpeningUpsertInputModel(JobOpeningUpsertInputModel jobOpeningUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(jobOpeningUpsertInputModel.JobOpeningTitle))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyJobOpeningName
                });
            }

            if (jobOpeningUpsertInputModel.JobOpeningTitle != null && jobOpeningUpsertInputModel.JobOpeningTitle.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionUpsertJobOpening
                });
            }

            if (jobOpeningUpsertInputModel.NoOfOpenings <=0 )
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyNoOfJobOpenings
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool JobOpeningSkillUpsertInputModel(JobOpeningSkillUpsertInputModel jobOpeningSkillUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            
            if (jobOpeningSkillUpsertInputModel.JobOpeningId == null || jobOpeningSkillUpsertInputModel.JobOpeningId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyJobOpeningName
                });
            }

            if (jobOpeningSkillUpsertInputModel.SkillId == null || jobOpeningSkillUpsertInputModel.SkillId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyJobOpeningSkill
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool CandidateSkillUpsertInputModel(CandidateSkillUpsertInputModel candidateSkillUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (candidateSkillUpsertInputModel.CandidateId == null || candidateSkillUpsertInputModel.CandidateId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCandidate
                });
            }

            if (candidateSkillUpsertInputModel.SkillId == null || candidateSkillUpsertInputModel.SkillId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySkill
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool CandidateExperirenceUpsertInputModel(CandidateExperienceUpsertInputModel candidateExperienceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (candidateExperienceUpsertInputModel.CandidateId == null || candidateExperienceUpsertInputModel.CandidateId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCandidate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool CandidateEducationUpsertInputModel(CandidateEducationUpsertInputModel candidateEducationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (candidateEducationUpsertInputModel.CandidateId == null || candidateEducationUpsertInputModel.CandidateId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCandidate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool CandidateDocumentUpsertInputModel(CandidateDocumentUpsertInputModel candidateDocumentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (candidateDocumentUpsertInputModel.CandidateId == null || candidateDocumentUpsertInputModel.CandidateId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCandidate
                });
            }

            if (string.IsNullOrEmpty(candidateDocumentUpsertInputModel.Document))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDocumentName
                });
            }

            if (candidateDocumentUpsertInputModel.Document != null && candidateDocumentUpsertInputModel.Document.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionUpsertCandidateDocument
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool DocumentTypeUpsertInputModel(DocumentTypeUpsertInputModel documentTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (string.IsNullOrEmpty(documentTypeUpsertInputModel.DocumentTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDocumentTypeName
                });
            }

            if (documentTypeUpsertInputModel.DocumentTypeName != null && documentTypeUpsertInputModel.DocumentTypeName.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionUpsertDocumentType
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool InterviewTypeUpsertInputModel(InterviewTypeUpsertInputModel interviewTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (string.IsNullOrEmpty(interviewTypeUpsertInputModel.InterviewTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyInterviewTypeName
                });
            }

            if (interviewTypeUpsertInputModel.InterviewTypeName != null && interviewTypeUpsertInputModel.InterviewTypeName.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionInterviewTypeName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool InterviewProcessUpsertInputModel(InterviewProcessUpsertInputModel interviewProcessUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (string.IsNullOrEmpty(interviewProcessUpsertInputModel.InterviewProcessName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyInterviewProcessName
                });
            }

            if (interviewProcessUpsertInputModel.InterviewProcessName != null && interviewProcessUpsertInputModel.InterviewProcessName.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionInterviewProcessName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool InterviewProcessConfigurationUpsertInputModel(InterviewProcessConfigurationUpsertInputModel interviewProcessConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            //if (string.IsNullOrEmpty(interviewProcessConfigurationUpsertInputModel.InterviewProcessConfigurationName))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyInterviewProcessConfigurationName
            //    });
            //}

            //if (interviewProcessConfigurationUpsertInputModel.InterviewProcessConfigurationName != null && interviewProcessConfigurationUpsertInputModel.InterviewProcessConfigurationName.Length > AppConstants.InputWithMaxSize100)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.ExceptionInterviewProcessConfigurationName
            //    });
            //}

            return validationMessages.Count <= 0;
        }

        public static bool CandidateInterviewScheduleUpsertInputModel(CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if(candidateInterviewScheduleUpsertInputModel.InterviewTypeId == null || candidateInterviewScheduleUpsertInputModel.InterviewTypeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyInterviewTypeName
                });
            }

            if(candidateInterviewScheduleUpsertInputModel.CandidateId == null || candidateInterviewScheduleUpsertInputModel.CandidateId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCandidate
                });
            }


            return validationMessages.Count <= 0;
        }

        public static bool CandidateInterviewFeedBackUpsertInputModel(CandidateInterviewFeedBackUpsertInputModel candidateInterviewFeedBackUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (candidateInterviewFeedBackUpsertInputModel.CandidateInterviewScheduleId == null || candidateInterviewFeedBackUpsertInputModel.CandidateInterviewScheduleId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyInterviewTypeName
                });
            }

            if (candidateInterviewFeedBackUpsertInputModel.InterviewRatingId == null || candidateInterviewFeedBackUpsertInputModel.InterviewRatingId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExeceptionInterviewRating
                });
            }


            return validationMessages.Count <= 0;
        }

        public static bool CandidateInterviewFeedBackCommentsUpsertInputModel(CandidateInterviewFeedBackCommentsUpsertInputModel candidateInterviewFeedBackCommentsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (candidateInterviewFeedBackCommentsUpsertInputModel.CandidateInterviewScheduleId == null || candidateInterviewFeedBackCommentsUpsertInputModel.CandidateInterviewScheduleId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyInterviewTypeName
                });
            }

            if (candidateInterviewFeedBackCommentsUpsertInputModel.AssigneeId == null || candidateInterviewFeedBackCommentsUpsertInputModel.AssigneeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyAssigneeId
                });
            }

            if (string.IsNullOrEmpty(candidateInterviewFeedBackCommentsUpsertInputModel.AssigneeComments))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyAssigneeComments
                });
            }
            
            return validationMessages.Count <= 0;
        }

        public static bool HiringStatusUpsertInputModel(HiringStatusUpsertInputModel hiringStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            
            if (string.IsNullOrEmpty(hiringStatusUpsertInputModel.Status))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyStatusName
                });
            }

            if (string.IsNullOrEmpty(hiringStatusUpsertInputModel.Color))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyColor
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool InterviewRatingUpsertInputModel(InterviewRatingUpsertInputModel interviewRatingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(interviewRatingUpsertInputModel.InterviewRatingName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRatingName
                });
            }

            if (string.IsNullOrEmpty(interviewRatingUpsertInputModel.Value))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyValue
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
