<?php

namespace App\Http\Controllers\TelegramBot;

use App\Models\Client;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Messages;
use Telegram\Bot\Laravel\Facades\Telegram;

class TelegramController extends Controller
{
    public function handleWebhook(Request $request)
    {
        // استلام التحديثات من Telegram
        $update = Telegram::getWebhookUpdates();
        $message = $update->getMessage();
        $chatId = $message->getChat()->getId();
        $text = $message->getText();

        // البحث عن العميل
        $client = Client::where('telegram_chat_id', $chatId)->first();

        if (!$client) {
            // التحقق من الكود المدخل
            $this->handleCodeInput($chatId, $text);
        } else {
            // تخزين الرسالة
            $this->storeMessage($client, $text);
        }
    }

    public function handleCodeInput($chatId, $text)
    {
        $client = Client::where('code', $text)->first();

        if ($client) {
            // حفظ chat_id
            $client->telegram_chat_id = $chatId;
            $client->save();

            // إرسال رسالة ترحيبية
            Telegram::sendMessage([
                'chat_id' => $chatId,
                'text' => "مرحبًا {$client->name}! كيف يمكننا مساعدتك؟",
            ]);
        } else {
            Telegram::sendMessage([
                'chat_id' => $chatId,
                'text' => "الكود غير صحيح. حاول مرة أخرى.",
            ]);
        }
    }

    public function storeMessage($client, $text)
    {
        Messages::create([
            'client_id' => $client->id,
            'message' => $text,
        ]);

        Telegram::sendMessage([
            'chat_id' => $client->telegram_chat_id,
            'text' => "تم استلام رسالتك. سنرد عليك قريبًا.",
        ]);
    }
}
