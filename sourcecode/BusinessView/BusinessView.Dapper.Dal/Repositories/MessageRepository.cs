using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class MessageRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Message table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(MessageDbEntity aMessage)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMessage.Id);
					 vParams.Add("@ChannelId",aMessage.ChannelId);
					 vParams.Add("@SenderUserId",aMessage.SenderUserId);
					 vParams.Add("@ReceiverUserId",aMessage.ReceiverUserId);
					 vParams.Add("@MessageTypeId",aMessage.MessageTypeId);
					 vParams.Add("@TextMessage",aMessage.TextMessage);
					 vParams.Add("@IsDeleted",aMessage.IsDeleted);
					 vParams.Add("@MessageDateTime",aMessage.MessageDateTime);
					 vParams.Add("@UpdatedDateTime",aMessage.UpdatedDateTime);
					 vParams.Add("@FilePath",aMessage.FilePath);
					 int iResult = vConn.Execute("USP_MessageInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Message table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(MessageDbEntity aMessage)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMessage.Id);
					 vParams.Add("@ChannelId",aMessage.ChannelId);
					 vParams.Add("@SenderUserId",aMessage.SenderUserId);
					 vParams.Add("@ReceiverUserId",aMessage.ReceiverUserId);
					 vParams.Add("@MessageTypeId",aMessage.MessageTypeId);
					 vParams.Add("@TextMessage",aMessage.TextMessage);
					 vParams.Add("@IsDeleted",aMessage.IsDeleted);
					 vParams.Add("@MessageDateTime",aMessage.MessageDateTime);
					 vParams.Add("@UpdatedDateTime",aMessage.UpdatedDateTime);
					 vParams.Add("@FilePath",aMessage.FilePath);
					 int iResult = vConn.Execute("USP_MessageUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Message table.
		/// </summary>
		public MessageDbEntity GetMessage(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<MessageDbEntity>("USP_MessageSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Message table.
		/// </summary>
		 public IEnumerable<MessageDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<MessageDbEntity>("USP_MessageSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Message table by a foreign key.
		/// </summary>
		public List<MessageDbEntity> SelectAllByChannelId(Guid? channelId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ChannelId",channelId);
				 return vConn.Query<MessageDbEntity>("USP_MessageSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
