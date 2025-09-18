using Btrak.Models;
using Btrak.Models.Training;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Training
{
    public interface ITrainingCourseService
    {
        List<TrainingCourse> SearchTrainingCourses(TrainingCourseSearchModel trainingCourseSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTrainingCourse(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TrainingCourse> GetTrainingCourses(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void AssignOrUnAssignTrainingCourse(AssignmentsInputModel assignments, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool ArchiveOrUnArchiveTrainingCourse(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool CheckSameCourseExists(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TrainingAssignmentOutPutModel> SearchTrainingAssignments(TrainingAssignmentSearchModel trainingAssignmentSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void AddOrUpdateAssignmentStatus(TrainingAssignment assignment, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AssignmentStatus> GetAssignmentStatuses(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TrainingWorkflow> GetAssignmentWorkflow(Guid assignmentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
