import gradio as gr

from llm import conversation

with gr.Blocks() as demo:
    chatbot = gr.Chatbot()
    prompt = gr.Textbox(placeholder="Enter your message here...")
    clear = gr.ClearButton([prompt, chatbot])
    clear.click(conversation.memory.clear)

    def llm_reply(prompt, chat_history):
        reply = conversation.predict(input=prompt)
        chat_history.append((prompt, reply))
        return "", chat_history

    prompt.submit(llm_reply, [prompt, chatbot], [prompt, chatbot])


def main():
    demo.launch(server_name="0.0.0.0", server_port=7860)


if __name__ == "__main__":
    main()
