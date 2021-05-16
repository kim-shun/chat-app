class MessagesController < ApplicationController
  def index
    @message = Message.new   #messages/_main_chatのform_withのモデルオプションに指定したインスタンスのセット
    @room = Room.find(params[:room_id]) # ↑ form_withの指定のチャットルームのレコード情報。作成したチャットルームにアクセスできる。
    @messages = @room.messages.includes(:user) #一覧画面で表示するメッセージ情報の取得。includesでユーザー情報を1度のアクセスでまとめて取得
  end

  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    if @message.save
      redirect_to room_messages_path(@room)
    else
      @messages = @room.messages.includes(:user) #renderの時にエラーが起きないようにする
      render :index
    end
  end

  private
  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id)
  end
end
