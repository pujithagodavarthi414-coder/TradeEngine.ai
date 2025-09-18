using Btrak.Models;
using Btrak.Services.Audit;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.TransitionDeadline;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.TransitionDeadline;

namespace Btrak.Services.TransitionDeadline
{
	public class TransitionDeadlineService : ITransitionDeadlineService
	{
		private readonly TransitionDeadlineRepository _transitionDeadlineRepository;
		private readonly IAuditService _auditService;

		public TransitionDeadlineService(TransitionDeadlineRepository transitionDeadlineRepository, IAuditService auditService)
		{
			_transitionDeadlineRepository = transitionDeadlineRepository;
			_auditService = auditService;
		}

		public Guid? UpsertTransitionDeadline(TransitionDeadlineUpsertInputModel transitionDeadlineUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
		{
			LoggingManager.Debug(transitionDeadlineUpsertInputModel.ToString());

			transitionDeadlineUpsertInputModel.Deadline = transitionDeadlineUpsertInputModel.Deadline?.Trim();

			if (!TransitionDeadlineValidations.ValidateUpsertTransitionDeadline(transitionDeadlineUpsertInputModel, loggedInContext, validationMessages))
			{
				return null;
			}

			transitionDeadlineUpsertInputModel.TransitionDeadlineId = _transitionDeadlineRepository.UpsertTransitionDeadline(transitionDeadlineUpsertInputModel, loggedInContext, validationMessages);

			_auditService.SaveAudit(AppCommandConstants.UpsertTransitionDeadlineCommandId, transitionDeadlineUpsertInputModel, loggedInContext);

			LoggingManager.Debug(transitionDeadlineUpsertInputModel.TransitionDeadlineId?.ToString());

			return transitionDeadlineUpsertInputModel.TransitionDeadlineId;
		}

		public List<TransitionDeadlineApiReturnModel> GetAllTransitionDeadlines(TransitionDeadlineInputModel transitionDeadlineInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
		{
			LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllTransitionDeadlines", "TransitionDeadline Service"));

			_auditService.SaveAudit(AppCommandConstants.GetAllTransitionDeadlinesCommandId, transitionDeadlineInputModel, loggedInContext);

			if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
			{
				return null;
			}

			List<TransitionDeadlineApiReturnModel> transitionDeadlineReturnModels = _transitionDeadlineRepository.GetAllTransitionDeadlines(transitionDeadlineInputModel, loggedInContext, validationMessages);

			return transitionDeadlineReturnModels;
		}

		public TransitionDeadlineApiReturnModel GetTransitionDeadlineById(Guid? transitionDeadlineId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
		{
			LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTransitionDeadlineById", "TransitionDeadline Service"));

			if (!TransitionDeadlineValidations.ValidateTransitionDeadlineById(transitionDeadlineId, loggedInContext, validationMessages))
			{
				return null;
			}

			var transitionDeadlineInputModel = new TransitionDeadlineInputModel
			{
				TransitionDeadlineId = transitionDeadlineId
			};

            TransitionDeadlineApiReturnModel transitionDeadlineReturnModel = _transitionDeadlineRepository.GetAllTransitionDeadlines(transitionDeadlineInputModel, loggedInContext, validationMessages).FirstOrDefault();

			if (!TransitionDeadlineValidations.ValidateTransitionDeadlineFoundWithId(transitionDeadlineId, validationMessages, transitionDeadlineReturnModel))
			{
				return null;
			}

			_auditService.SaveAudit(AppCommandConstants.GetTransitionDeadlineByIdCommandId, transitionDeadlineInputModel, loggedInContext);

            return transitionDeadlineReturnModel;
		}
	}
}