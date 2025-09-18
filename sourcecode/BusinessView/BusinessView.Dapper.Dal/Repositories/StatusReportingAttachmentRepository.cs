using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class StatusReportingAttachmentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the StatusReportingAttachment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(StatusReportingAttachmentDbEntity aStatusReportingAttachment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReportingAttachment.Id);
					 vParams.Add("@StatusReportingId",aStatusReportingAttachment.StatusReportingId);
					 vParams.Add("@FileId",aStatusReportingAttachment.FileId);
					 vParams.Add("@IsSubmitted",aStatusReportingAttachment.IsSubmitted);
					 vParams.Add("@CreatedDateTime",aStatusReportingAttachment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStatusReportingAttachment.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStatusReportingAttachment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReportingAttachment.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StatusReportingAttachmentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the StatusReportingAttachment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(StatusReportingAttachmentDbEntity aStatusReportingAttachment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReportingAttachment.Id);
					 vParams.Add("@StatusReportingId",aStatusReportingAttachment.StatusReportingId);
					 vParams.Add("@FileId",aStatusReportingAttachment.FileId);
					 vParams.Add("@IsSubmitted",aStatusReportingAttachment.IsSubmitted);
					 vParams.Add("@CreatedDateTime",aStatusReportingAttachment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStatusReportingAttachment.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStatusReportingAttachment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReportingAttachment.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StatusReportingAttachmentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of StatusReportingAttachment table.
		/// </summary>
		public StatusReportingAttachmentDbEntity GetStatusReportingAttachment(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<StatusReportingAttachmentDbEntity>("USP_StatusReportingAttachmentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the StatusReportingAttachment table.
		/// </summary>
		 public IEnumerable<StatusReportingAttachmentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<StatusReportingAttachmentDbEntity>("USP_StatusReportingAttachmentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the StatusReportingAttachment table by a foreign key.
		/// </summary>
		public List<StatusReportingAttachmentDbEntity> SelectAllByStatusReportingId(Guid statusReportingId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@StatusReportingId",statusReportingId);
				 return vConn.Query<StatusReportingAttachmentDbEntity>("USP_StatusReportingAttachmentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
