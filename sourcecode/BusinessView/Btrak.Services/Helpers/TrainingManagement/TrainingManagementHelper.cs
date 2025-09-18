using Btrak.Models;
using Btrak.Models.Training;
using Btrak.Services.Training;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers
{
    public class TrainingManagementHelper
    {
        public static bool ValidateUpsertTrainingCourse(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(trainingCourse.CourseName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCourseName
                });
            }

            if (trainingCourse.CourseName?.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForCourseName
                });
            }

            bool courseNameExists = new TrainingCourseService().CheckSameCourseExists(trainingCourse, loggedInContext, validationMessages);

            if (courseNameExists)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ValidationSameCourseNameExists
                });
            }

            if (string.IsNullOrEmpty(trainingCourse.CourseDescription))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCourseDescription
                });
            }

            if (trainingCourse.CourseDescription?.Length > AppConstants.InputWithMaxSize800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForCourseDescription
                });
            }

            if (trainingCourse.ValidityInMonths <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ValidityCannotBeZeroOrNegative
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateArchiveTrainingCourse(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            bool activeAssignmentsExists = new TrainingCourseService().CheckActiveAssignmentsExists(trainingCourse, loggedInContext, validationMessages);

            if (activeAssignmentsExists)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ValidationArchiveCannotHappen
                });
            }
            return activeAssignmentsExists;
        }
    }
}
