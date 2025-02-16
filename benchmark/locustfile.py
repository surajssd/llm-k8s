import random
import time
import os

from locust import HttpUser, between, task

questions = [
    "What were the key causes of World War I, and how did alliances contribute to the conflict?",
    "How did the Treaty of Versailles shape the geopolitical landscape of Europe in the 20th century?",
    "What were the major achievements and failures of the Roman Empire?",
    "How did the Industrial Revolution change the economic and social structures of Europe?",
    "What were the primary motivations for European exploration during the Age of Discovery?",
    "How did the American Revolution influence other independence movements around the world?",
    "What role did propaganda play in shaping public opinion during World War II?",
    "How did the Cold War impact the development of new technologies?",
    "What were the long-term effects of the fall of the Berlin Wall?",
    "How did the Renaissance contribute to the development of modern Western civilization?",
    "What were the major social and economic consequences of the Black Death?",
    "How did the Great Depression influence global political movements?",
    "What role did women play in the French Revolution, and how did their participation affect the outcome?",
    "How did the Ottoman Empire rise to power, and what factors led to its decline?",
    "How did the Mongol Empire facilitate cultural exchange across Eurasia?",
    "What were the major differences between the political philosophies of Thomas Hobbes and John Locke?",
    "How did the spread of Islam shape societies in the Middle Ages?",
    "What were the key strategies that enabled the Byzantine Empire to survive for over a thousand years?",
    "How did the Meiji Restoration transform Japan's economy and society?",
    "What were the causes and consequences of the Indian Rebellion of 1857?",
    "How did the transatlantic slave trade affect African societies?",
    "What were the major impacts of the printing press on European society?",
    "How did the Protestant Reformation change religious and political structures in Europe?",
    "What role did the Enlightenment play in shaping modern democratic thought?",
    "How did the Haitian Revolution challenge European colonialism?",
    "What were the major causes and consequences of the Opium Wars?",
    "How did Napoleon's rule change France and Europe?",
    "What were the primary objectives of the League of Nations, and why did it fail?",
    "How did the Marshall Plan contribute to the reconstruction of Europe after World War II?",
    "What were the key factors leading to the fall of the Soviet Union?",
    "How did the Civil Rights Movement in the United States inspire global human rights movements?",
    "What were the major effects of European imperialism in Africa?",
    "How did ancient Greek philosophy influence later scientific and political thought?",
    "What role did trade routes like the Silk Road play in shaping world history?",
    "How did the Scientific Revolution challenge existing beliefs and institutions?",
    "What were the major consequences of the Spanish conquest of the Americas?",
    "How did feudalism shape medieval European society?",
    "What were the key factors leading to the unification of Italy?",
    "How did the Indian independence movement develop over time?",
    "What were the major impacts of the Cold War on developing nations?",
    "How did technological innovations influence World War I and II?",
    "What were the cultural and political effects of the Great Migration in the United States?",
    "How did the Zulu Kingdom rise and fall in Southern Africa?",
    "What were the major contributions of ancient Mesopotamian civilizations?",
    "How did geography influence the development of early civilizations?",
    "What were the key differences between capitalism and communism during the 20th century?",
    "How did the American Civil War reshape the United States?",
    "What role did espionage play during the Cold War?",
    "How did ancient Chinese inventions influence global technological advancements?",
    "What were the major causes and effects of the Crusades?",
    "How did nationalism contribute to conflicts in the 19th and 20th centuries?",
    "What was the significance of the Balfour Declaration in Middle Eastern history?",
    "How did the spread of the bubonic plague influence European society?",
    "What role did colonial economies play in shaping modern global trade?",
    "How did the Berlin Conference impact Africa's political boundaries?",
    "What were the major achievements of the Abbasid Caliphate?",
    "How did the Vietnam War shape U.S. foreign policy?",
    "What were the effects of decolonization in the mid-20th century?",
    "How did the Treaty of Tordesillas shape the colonization of the Americas?",
    "What role did labor movements play in the development of workers' rights?",
    "How did the Weimar Republic contribute to the rise of Nazi Germany?",
    "What were the social and economic consequences of the Irish Potato Famine?",
    "How did ancient Egyptian civilization influence later cultures?",
    "What were the primary challenges faced by the United Nations in its early years?",
    "How did the Great Fire of London change urban planning and architecture?",
    "What were the major accomplishments of Charlemagne?",
    "How did the Harlem Renaissance impact American culture?",
    "What were the effects of the Spanish-American War on global geopolitics?",
    "How did the Trans-Saharan trade routes influence African history?",
    "What were the causes and effects of the War of 1812?",
    "How did the concept of chivalry shape medieval European society?",
    "What role did mercantilism play in European colonial expansion?",
    "How did the Enlightenment contribute to the American and French Revolutions?",
    "What were the impacts of the development of the steam engine on industrialization?",
    "How did Genghis Khan's leadership impact the Mongol Empire?",
    "What were the major differences between the French and American Revolutions?",
    "How did the construction of the Suez Canal affect global trade?",
    "What were the consequences of the Thirty Years' War?",
    "How did the invention of gunpowder change military history?",
    "What role did religious conflicts play in shaping European history?",
    "How did the Gold Rush influence migration patterns in the 19th century?",
    "What were the major achievements of the Mughal Empire?",
    "How did early human migrations shape different civilizations?",
    "What were the long-term effects of the Spanish Civil War?",
    "How did the discovery of the New World alter global trade routes?",
    "What were the effects of the Reign of Terror during the French Revolution?",
    "How did the abolition of slavery shape economic structures in the 19th century?",
    "What role did Viking exploration play in European history?",
    "How did the Cold War shape space exploration?",
    "What were the causes and consequences of the Boxer Rebellion?"
]

class ChatUser(HttpUser):
    wait_time = between(5, 20)

    @task
    def ask_question(self):
        model_name=os.getenv("MODEL_NAME")

        first_question = random.choice(questions)

        response = self.client.post(
            "/v1/chat/completions",
            name="initial chat",
            json={
                "messages": [
                    {
                        "content": first_question,
                        "role": "user",
                    },
                ],
                "model": model_name,
            },
        )

        time.sleep(self.wait_time())

        # use one of the follow up questions.
        follow_up_question = random.choice(questions)
        result_message = response.json()["choices"][0]["message"]["content"]

        response = self.client.post(
            "/v1/chat/completions",
            name="follow up chat",
            json={
                "messages": [
                    {"content": first_question, "role": "user"},
                    {
                        "content": result_message,
                        "role": "assistant",
                    },
                    {"content": follow_up_question, "role": "user"},
                ],
                "model": model_name,
            },
        )
