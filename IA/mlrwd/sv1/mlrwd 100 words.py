import nltk


def tokenise():
    # this is a quote from "The Merchant of Venice" -- Shylock is doing a monologue insulting Antonio.
    txt = """
    How like a fawning publican he looks!
    I hate him for he is a Christian,
    But more for that in low simplicity
    He lends out money gratis and brings down
    The rate of usance here with us in Venice.
    If I can catch him once upon the hip,
    I will feed fat the ancient grudge I bear him.
    He hates our sacred nation, and he rails,
    Even there where merchants most do congregate,
    On me, my bargains and my well-won thrift,
    Which he calls interest. Cursed be my tribe,
    If I forgive him!
    """
    words = []
    words.extend(nltk.tokenize.word_tokenize(txt.strip()))
    return sorted([w.lower() for w in words])


if __name__ == '__main__':
    # print(sorted(list(dict.fromkeys(tokenise()))))
    wordsforben = ['!', ',', '.', 'a', 'ancient', 'and', 'bargains', 'be', 'bear', 'brings', 'but', 'calls', 'can',
                   'catch', 'christian', 'congregate', 'cursed', 'do', 'down', 'even', 'fat', 'fawning', 'feed', 'for',
                   'forgive', 'gratis', 'grudge', 'hate', 'hates', 'he', 'here', 'him', 'hip', 'how', 'i', 'if', 'in',
                   'interest', 'is', 'lends', 'like', 'looks', 'low', 'me', 'merchants', 'money', 'more', 'most', 'my',
                   'nation', 'of', 'on', 'once', 'our', 'out', 'publican', 'rails', 'rate', 'sacred', 'simplicity',
                   'that', 'the', 'there', 'thrift', 'tribe', 'upon', 'us', 'usance', 'venice', 'well-won', 'where',
                   'which', 'will', 'with']
    wordsfromben = ['!', "'s", '(', ')', ',', '.', 'a', 'advanced', 'algorithms', 'also', 'am', 'an', 'and', 'are',
                    'as', 'at', 'beginner-friendly', 'being', 'bought', 'companion', 'concepts', 'consider', 'course',
                    'covered', 'definitely', 'despite', 'ece358', 'especially', 'everything', 'for', 'go', 'great',
                    'hardcover', 'heavy', 'helpful', 'i', 'if', 'includes', 'introductory', 'is', 'it', 'large', 'like',
                    'loving', 'maybe', 'myself', 'not', 'of', 'overall', 'pseudocode', 'quite', 'recommend', 'said',
                    'snippets', 'some', 'still', 'textbook', 'that', 'the', 'this', 'uoft', 'very', 'visualization',
                    'would', 'you']
    print(len(wordsfromben))
    """for i in range(len(wordsfromben) // 3):
        print(wordsfromben[3 * i] + " & " + " & " + wordsfromben[3 * i + 1] + " & " + " & " + wordsfromben[3 * i + 2] + " & " + "\\\\")"""
