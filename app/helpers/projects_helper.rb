module ProjectsHelper
  def like_dislike_link card
    if @voted_card == card
      link_to([@project, card, :votes], method: (@voted_card == card ? :delete : :post), class: 'btn btn-danger') do
        t('general.dislike')
      end
    elsif @voted_card.nil?
      link_to([@project, card, :votes], method: (@voted_card == card ? :delete : :post), class: 'btn btn-success') do
        t('general.like')
      end
    else
      link_to('#', class: 'btn btn-success disabled') do
        t('general.like')
      end
    end
  end

  def format_fee_amount amount
    if amount.blank?
      t('general.fee_blank_amount')
    else
      currency amount
    end
  end

  def format_close_dialog_message project
    paid_type = project.paid_type

    if project.paid_info.nil?
      "<div class='no_paid_info'>#{t('general.close_project.empty_paid_info')}</div>"
    else
      t("general.close_project.#{paid_type}", amount: currency(@project.donated_amount), account: project.paid_info.account_identifier).html_safe
    end
  end

  def format_notification_message notification
    if notification.event_params['amount'].present?
      notification.event_params['amount'] = currency notification.event_params['amount']
    end

    event_params = notification.event_params.symbolize_keys.merge({time: notification.created_at})
    t("general.events.#{notification.event_type}", event_params).html_safe
  end

  def format_total_amount amount
    amount = amount.blank? ? t('general.no_world') : currency(amount)
    t('general.total_amount', amount: amount).html_safe
  end

  def currency(amount)
    number_to_currency(amount, unit: currency_unit('EUR'))
  end

  def currency_unit(abbr)
    {'EUR' => '&euro;'}[abbr]
  end
end