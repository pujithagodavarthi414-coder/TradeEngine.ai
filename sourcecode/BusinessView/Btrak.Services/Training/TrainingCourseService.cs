using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.Expenses;
using Btrak.Models.Training;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.Training
{
    public class TrainingCourseService : ITrainingCourseService
    {
        private readonly IAuditService _auditService;
        private readonly TrainingCourseRepository _trainingCourseRepository;

        public TrainingCourseService(
            IAuditService auditService,
            TrainingCourseRepository trainingCourseRepository
        )
        {
            _auditService = auditService;
            _trainingCourseRepository = trainingCourseRepository;
        }

        public TrainingCourseService()
        {
        }

        public bool ArchiveOrUnArchiveTrainingCourse(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchiveTrainingCourse", "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            if (trainingCourse.IsArchived && TrainingManagementHelper.ValidateArchiveTrainingCourse(trainingCourse, loggedInContext, validationMessages))
            {
                return false;
            }

            return _trainingCourseRepository.ArchiveOrUnArchiveTrainingCourse(trainingCourse, loggedInContext, validationMessages);
        }

        public void AssignOrUnAssignTrainingCourse(AssignmentsInputModel assignments, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AssignOrUnAssignTrainingCourse", "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            _trainingCourseRepository.AssignOrUnAssignTrainingCourse(assignments, loggedInContext, validationMessages);
        }

        public List<TrainingCourse> GetTrainingCourses(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTrainingCourses", "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            var trainingCourses = _trainingCourseRepository.GetTrainingCourses(loggedInContext, validationMessages);

            return trainingCourses;
        }

        public List<TrainingCourse> SearchTrainingCourses(TrainingCourseSearchModel trainingCourseSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, trainingCourseSearchModel, "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            LoggingManager.Debug(trainingCourseSearchModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchTrainingCoursesCommandId, trainingCourseSearchModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<TrainingCourse> trainingCourses = _trainingCourseRepository.SearchTrainingCourses(trainingCourseSearchModel, loggedInContext, validationMessages).ToList();

            return trainingCourses;
        }

        public bool CheckActiveAssignmentsExists(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckActiveAssignmentsExists", "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            LoggingManager.Debug(trainingCourse.ToString());

            return new TrainingCourseRepository().CheckActiveAssignmentsExists(trainingCourse, loggedInContext, validationMessages);
        }

        public Guid? UpsertTrainingCourse(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTrainingCourse", "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            LoggingManager.Debug(trainingCourse.ToString());

            if (!TrainingManagementHelper.ValidateUpsertTrainingCourse(trainingCourse, loggedInContext, validationMessages))
            {
                return null;
            }

            var id = _trainingCourseRepository.UpsertTrainingCourse(trainingCourse, loggedInContext, validationMessages);

            return id;
        }

        public bool CheckSameCourseExists(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckSameCourseExists", "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            LoggingManager.Debug(trainingCourse.ToString());

            return  new TrainingCourseRepository().CheckSameCourseExists(trainingCourse, loggedInContext, validationMessages);
        }

        public List<TrainingAssignmentOutPutModel> SearchTrainingAssignments(TrainingAssignmentSearchModel trainingAssignmentSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTrainingAssignments", "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            LoggingManager.Debug(trainingAssignmentSearchModel.ToString());

            return _trainingCourseRepository.SearchTrainingAssignments(trainingAssignmentSearchModel, loggedInContext, validationMessages);
        }

        public void AddOrUpdateAssignmentStatus(TrainingAssignment assignment, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AddOrUpdateAssignmentStatus", "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            //LoggingManager.Debug(assignment.ToString());

            _trainingCourseRepository.AddOrUpdateAssignmentStatus(assignment, loggedInContext, validationMessages);
        }

        public List<AssignmentStatus> GetAssignmentStatuses(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAssignmentStatuses", "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            return _trainingCourseRepository.GetAssignmentStatuses(loggedInContext, validationMessages);
        }

        public List<TrainingWorkflow> GetAssignmentWorkflow(Guid assignmentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAssignmentWorkflow", "TrainingCourseService and logged details=" + loggedInContext, validationMessages));

            return _trainingCourseRepository.GetAssignmentWorkflow(assignmentId, loggedInContext, validationMessages);
        }
    }
}
